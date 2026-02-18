class Resume < ActiveRecord::Base
  require 'rubygems'
  require 'sanitize'

  searchkick word_start: [:name, :email, :phone, :qualification, :location, :preferred_location, :resume_search_content, :skills, :current_company],
            suggest: [:name, :email, :phone, :qualification, :location, :preferred_location],
            filterable: [:id, :ctc, :expected_ctc, :exp_in_months, :overall_status, :related_requirements, :notice, :status, :uniqid, :preferred_location, :location],
            searchable: [:name, :email, :phone, :qualification, :location, :preferred_location, :summary, :resume_search_content, :overall_status, :related_requirements, :skills, :current_company],
            knn: {embedding: {dimensions: 1536, distance_type: "cosine"}},
            mappings: {
              properties: {
                id: { type: 'integer' },
                exp_in_months: { type: 'integer' },
                ctc: { type: 'float' },
                expected_ctc: { type: 'float' },
                notice: { type: 'integer' },
                created_at: { type: 'date' },
                updated_at: { type: 'date' },
                embedding: { type: 'dense_vector', dims: 1536 } # OpenAI text-embedding-3-small embedding dimensions
              }
            },
            merge_mappings: true
  
  before_save :normalize_searchable_fields
  belongs_to               :uniqid
  belongs_to               :employee
  belongs_to               :ta_owner,
                           :optional => true,
                           :class_name => "Employee",
                           :foreign_key => "ta_owner_id"
  has_many                 :feedbacks
  has_many                 :messages
  has_many                 :forwards,
                           :class_name  => "Forward",
                           :foreign_key => "resume_id"
  has_many                 :req_matches,
                           :class_name  => "ReqMatch",
                           :foreign_key => "resume_id"
  has_many                 :comments,
                           :class_name  => "Comment",
                           :foreign_key => "resume_id"

  # Presence stuff
  validates_presence_of    :name
  validates_presence_of    :referral_type
  validates_presence_of    :referral_id
  validates_presence_of    :email
  validates_presence_of    :phone
  validates :skills, length: { maximum: 500 }

  # Figure out why this is used here
  # validate_on_create  :email
  # validate_on_create  :phone

  # Uniqueness stuff
  validates_uniqueness_of :email, case_sensitive: false
  validates_uniqueness_of :phone, case_sensitive: false

  # Stuff which should be done exactly before validation
  before_validation :remove_whitespaces

  after_save :update_overall_status
  after_save :update_search_fields
  after_update :expire_joined_cache

  # Format stuff
  validates_format_of      :email, :with => /([\w]+)@([\w]+)\./
  validate :notice_period_allowed_values

  def notice_period_allowed_values
    return if notice.nil?
    allowed = [0, 15, 30, 45, 60, 90]
    return if allowed.include?(notice.to_i)
    # Allow existing value when editing without changing notice (preserve legacy data)
    return if persisted? && notice_was.present? && notice.to_i == notice_was.to_i
    errors.add(:notice, "must be 0, 15, 30, 45, 60, or 90 days")
  end

  # Appending date-time to file names
  current_time      = Time.now
  $date_time_suffix = current_time.strftime("%d-%b-%Y-%H-%M-%S")
  $tmp_status_file  = APP_CONFIG['status_file']   + "-" + $date_time_suffix + ".xls"
  $tmp_xls          = APP_CONFIG['xls_temp_file'] + "-" + $date_time_suffix 
  $tmp_zip          = APP_CONFIG['zip_temp_file'] + "-" + $date_time_suffix
  $tmp_file         = APP_CONFIG['temp_file']
  $upload_dir       = APP_CONFIG['upload_directory']
  $tmp_directory    = APP_CONFIG['temp_directory']
  $tmp_resumes_directory  = $tmp_directory + '/' + APP_CONFIG['temp_resumes']

  def normalize_searchable_fields
    if self.resume_text_content
      self.resume_text_content = self.resume_text_content.encode('UTF-8', 'UTF-8', :invalid => :replace, :replace => '').gsub(/[\u{10000}-\u{10FFFF}]/, '')
    end
    self.preferred_location = self.preferred_location&.strip&.downcase
    self.location = self.location&.strip&.downcase
    self.name = self.name&.strip
    self.phone = self.phone&.strip
    self.email = self.email&.strip
  end

  def rejected?
    return self.status == "REJECTED" if self.status.present?
  
    has_non_rejected_req_matches = req_matches.where.not(status: "REJECTED").exists?
    return false if has_non_rejected_req_matches
  
    has_non_rejected_forwards = forwards.where.not(status: ["REJECTED", "ACTION TAKEN"]).exists?
    return false if has_non_rejected_forwards
  
    return true
  end

  def req_for_decision
    req_matches = self.req_matches
    return nil if req_matches.size == 0
    return req_matches.first.requirement if req_matches.size == 1
    # Go over req_matches in latest updated to previous
    req_matches = req_matches.sort_by {|r| r.updated_at}.reverse
    req_matches.each do |req_match|
      if req_match.status == "ENG_SELECT" || req_match.status == "SELECTED" || req_match.status == "SCHEDULED"
        return req_match.requirement
      end
    end
    return nil
  end

  def recreate_resume_text_content
    file_path, _, ext = preferred_file
    if file_path && ext != 'txt'
      # Use comprehensive text extraction that handles all file types
      txt = TextExtractor.extract_text_from_any_file(file_path)
      if txt && !txt.empty?
        # Save extracted text to file
        txt_file_name = File.join($upload_dir, self.file_name + '.txt')
        File.open(txt_file_name, "w") { |f| f << txt }
        create_search_data(txt)
      end
    end
  end

  def calculate_overall_status
    return self.status.upcase if self.status != ""

    req_statuses = req_matches.pluck(:status)
    forward_statuses = forwards.where.not(status: "ACTION TAKEN").pluck(:status)
    all_statuses = req_statuses + forward_statuses

    # Priority-based status determination
    return "JOINING" if all_statuses.include?("JOINING")
    return "OFFERED" if all_statuses.include?("OFFERED")
    return "YTO" if all_statuses.include?("YTO")
    return "HAC" if all_statuses.include?("HAC")
    return "ENG_SELECT" if all_statuses.include?("ENG_SELECT")
    return "HOLD" if all_statuses.include?("HOLD")
    return "SCHEDULED" if all_statuses.include?("SCHEDULED")
    return "SHORTLISTED" if all_statuses.include?("SHORTLISTED")
    return "FORWARDED" if all_statuses.include?("FORWARDED")
    return "NEW" if all_statuses.empty?
    return "REJECTED" if all_statuses.all? { |s| s == "REJECTED" }
  end

  def Resume.get_resume_statuses
    ["Any", "JOINING", "OFFERED", "HOLD", "SELECTED", "SCHEDULED", "SHORTLISTED", "FORWARDED", "NEW", "REJECTED", "FUTURE", "HAC", "N_ACCEPTED", "NOT JOINED"]
  end

  STATUS_TITLES = {
    "JOINING" => "Joining",
    "OFFERED" => "Offered", 
    "YTO" => "Yet To Offer",
    "ENG_SELECT" => "Engg. Select",
    "HOLD" => "On Hold",
    "SCHEDULED" => "Interview Scheduled",
    "SHORTLISTED" => "Shortlisted",
    "FORWARDED" => "Forwarded",
    "NEW" => "New",
    "REJECTED" => "Rejected",
    "FUTURE" => "Future",
    "HAC" => "HAC",
    "N_ACCEPTED" => "Not Accepted",
    "NOT JOINED" => "Not Joined",
    "JOINED" => "Joined"
  }.freeze

  def get_resume_overall_status_title
    STATUS_TITLES[self.overall_status] || "Unknown"
  end

  def move_temp_file_to_upload_directory
    upload_dir = Rails.root.join(APP_CONFIG['upload_directory'])
    Dir.mkdir(upload_dir) if not Dir.exist?(upload_dir)
    filenames = `ls #{$tmp_directory}/#{$tmp_file}.*`.split("\n")
    filenames.each do |filename|
      ext = File.extname(filename)
      `mv -f #{filename} '#{upload_dir}/#{self.file_name}'#{ext}`
    end
  end

  def cleanup_update_resume_data(upload_field)
    resume_file_name  = self.file_name
    if resume_file_name && resume_file_name != ""	
      # Deleting already existing resume files from upload directory	
      `rm -rf #{$upload_dir}/#{resume_file_name}.*`	
    end

    # Uploading resume file to upload directory
    ext = File.extname(upload_field.original_filename)
    filename = File.join($upload_dir, self.file_name + ext)
    File.open(filename, "w") { |f| f.write(upload_field.read.force_encoding("UTF-8")) }
    add_html_txt_and_search(filename)
    move_temp_file_to_upload_directory
  end

  def other_docs_path
    upload_dir = Rails.root.join(APP_CONFIG['upload_directory']).join(self.id.to_s)
    `ls #{upload_dir}/*`.split("\n")
  end

  def resume_path
    `ls #{Rails.root.join(APP_CONFIG['upload_directory'])}/#{self.file_name}.*`.split("\n")
  end

  def upload_document(upload_field)
    upload_dir = Rails.root.join(APP_CONFIG['upload_directory']).join(self.id.to_s)
    Dir.mkdir(upload_dir) if not Dir.exist?(upload_dir)
    original_filename = upload_field['upload_resume'].original_filename
    tempfile = Tempfile.new("resume_tmp", :encoding => 'ascii-8bit')
    tempfile.write(upload_field['upload_resume'].read)
    tempfile.close
    fullpathname      = upload_dir.join(original_filename)
    tempfile = File.open(tempfile.path)
    File.open(fullpathname, 'w') { |f| f.write(tempfile.read) }
  end
  def add_resume_comment(comment, ctype, employee)
    Comment.new(:comment     => comment,
                :resume_id   => self.id,
                :ctype       => ctype,
                :employee_id => employee.id).save!
  end

  def get_resume_req_matches(employee)
    matches_array = []
    matches       = self.req_matches.find_all { |r|
			employee.is_HR?    ||
      employee.is_ADMIN? || employee.is_GM? ||
      r.requirement.employee == employee || r.requirement.eng_leads.include?(employee)
    }
    matches.each do |m|
      matches_array.push([m.requirement.name, m.id])
    end
    matches_array
  end

  def delete_resume_details
    # Delete resume forwards
    self.forwards.each do |f|
      f.destroy
    end
    # Delete resume req_matches
    self.req_matches.each do |r|
      # Delete interviews related to req matches
      r.interviews.each do |i|
        i.destroy
      end
      r.destroy
    end
    # Delete resume comments
    self.comments.each do |c|
      c.destroy
    end
    # Delete resume feedbacks
    self.feedbacks.each do |f|
      f.destroy
    end
    # Delete uniqid
    self.uniqid.destroy if self.uniqid
    # Delete resume itself
    self.destroy
  end

  def rating
    total = 0
    feedbacks.each do |f|
      total += f.numerical_rating
    end
    if feedbacks.size > 0
      total /= feedbacks.size
    else
      total = "N/A"
    end
    total
  end

  def referral_name
    ref_name = ""
    if (referral_id == 0)
      return ref_name
    end
    if referral_type == "EMPLOYEE"
      ref_name     = Employee.find(referral_id).name
    elsif referral_type == "PORTAL"
      ref_name     = Portal.find(referral_id).name
    elsif referral_type == "AGENCY"
      ref_name     = Agency.find(referral_id).name
    end
    ref_name
  end

  def change_date
    last_change_date = self.updated_at
    if self.comments.size > 0
      last_comment_date = self.comments.last.updated_at
      if last_comment_date > last_change_date
        last_change_date = last_comment_date
      end
    end
    last_change_date
  end

  def get_current_experience
    year = 0
    month = 0
    unless self.experience.nil?
      year_split = self.experience.split("-")[0].to_i
      month_split = self.experience.split("-")[1].to_i
      no_months = (month_split) + (12 * year_split)
      # Alok: TBD
      # months_passed = (Date.today - self.created_at.to_date).to_i/30
      months_passed = 0
      total_months = no_months + months_passed
      year = total_months/12
      month = total_months % 12
    end
    [ year, month ]
  end

  def add_html_txt_and_search(fullpathname)

    # Use comprehensive text extraction that handles all file types
    txt = TextExtractor.extract_text_from_any_file(fullpathname)
    logger.info("Extracted txt: #{txt}")
    # Save extracted text to file
    if txt && !txt.empty?
      txt_file_name = File.join($upload_dir, self.file_name + '.txt')
      File.open(txt_file_name, "w") { |f| f << txt }
      create_search_data(txt)
    end

  end

  def Resume.upload_xls(exl_file, zipped_file, logged_employee, current_employee)
    require 'spreadsheet'

    if exl_file.nil? || zipped_file.nil?
      return nil, "File is missing"
    end

    ext     = File.extname(exl_file.original_filename)
    xls_temp_file_name = File.join($tmp_directory, $tmp_xls) + ext
    if ext == ".xls"
      Resume.read_upload_write_tmp_file(xls_temp_file_name, exl_file)
    else
      return nil, "No excel file"
    end

    ext = File.extname(zipped_file.original_filename)
    zip_temp_file_name = File.join($tmp_directory, $tmp_zip) + ext
    if (ext == ".zip")
      Resume.read_upload_write_tmp_file(zip_temp_file_name, zipped_file)
      FileUtils.mkdir_p($tmp_resumes_directory)
      `unzip #{zip_temp_file_name} -d #{$tmp_resumes_directory}/`
    else
      return nil, "No zip file"
    end

    worksheet        = Spreadsheet.open(xls_temp_file_name).worksheet(0)
    if worksheet.nil?
      return nil, "No data"
    else
      book             = Spreadsheet::Workbook.new
      status_sheet     = book.create_worksheet :name => "Status"
    	status_file      = File.join($tmp_directory, $tmp_status_file);
      row_index = 0
      worksheet.each do |row|
        resume = Resume.new
        if row_index == 0
          resume.write_header_to_status_file(status_sheet, row) 
        else
          resume.create_resume_from_XL_row(row, logged_employee, current_employee)
          resume.write_to_status_file(status_sheet, row, row_index)
        end
        row_index = row_index + 1
      end
      book.write status_file
      return status_file, nil
    end
  end

  def create_resume_from_XL_row(row, logged_employee, current_employee)
    self.name  = row.at(0).strip
    self.email = row.at(1).strip
    self.phone = row.at(2)
    self.ctc   = row.at(3)
    self.expected_ctc     = row.at(4)
    self.notice           = row.at(5)
    self.experience       = row.at(6)
    self.current_company  = row.at(7).strip
    self.location         = row.at(8).strip
    self.qualification    = row.at(9).strip
    requirement_name      = row.at(10).strip
    vendor_name           = row.at(11).strip
    file_name             = row.at(12).strip
    self.summary          = row.at(13).nil? ? "No summary provided because this resume is uploaded with XLS script" : row.at(13).strip;

    # Find vendor id and requirement id
    requirement = Requirement.find_by_name(requirement_name)
    if requirement_name && requirement.nil?
      msg = "Requirement name #{requirement_name} not found in our database"
      errors.add(msg)
      return false
    end

    vendor = Agency.find_by_name(vendor_name)
    if vendor.nil?
      msg = "Vendor name #{vendor_name} not found in our database"
      errors.add(msg)
      return false
    end
    self.referral_type = "AGENCY"
    self.referral_id   = vendor.id
    self.uniqid  ||= Uniqid.generate_unique_id(self.name, self)
    self.file_name = self.uniqid.name.downcase

    # Moving resumes residing in tmp/temp_resumes/ directory to tmp/
    ext         = File.extname(file_name)
    tmp_file    = File.join($tmp_directory, $tmp_file) + ext
    resume_file_name = File.join("#{$tmp_resumes_directory}/#{file_name}").gsub(/ /, "\\ ")
    `mv -f #{resume_file_name} #{tmp_file}`
    if self.save
      add_html_txt_and_search(file_name)
      comment = "UPLOADING: #{logged_employee.name} uploaded resume on #{self.created_at.strftime('%b %d, %Y')} from XLS script."
      add_resume_comment(comment, "EXTERNAL", logged_employee)
      if (requirement)
        Resume.create_reqs(self, requirement.id.to_a, logged_employee, current_employee)
      end
      move_temp_file_to_upload_directory
      return true
    end
  end

  def write_header_to_status_file(status_sheet, row)
    status_sheet.row(0).concat row
    status_sheet.row(0).height = 20
    status_sheet.row(0).push "STATUS"
    0.upto(15).each { |col| status_sheet.column(col).width = 30 }
    title_format = Spreadsheet::Format.new( {:weight => :bold, :pattern_fg_color => :grey, :size => 10, :color => :white, :pattern => 1 } )
    status_sheet.row(0).default_format = title_format
  end

  def write_to_status_file(status_sheet, row, row_index)
    status_sheet.row(row_index).concat row
    if self.errors.blank?
      status_sheet.row(row_index).push "SUCCESS"
    else
      resume_errors = ""
      self.errors.each_full { |mesg|
        resume_errors += mesg.sub(/is invalid/, "") + "\n"
      }
      status_sheet.row(row_index).push resume_errors
    end
  end

  ####################################################################################################
  # FUNCTIONS   : create_reqs                                                                        #
  # DESCRIPTION : Function to be used to Create reqs when req_ids will come instead of req_match_id. #
  #               Generally this function is used when we forward resume to somebody.                #
  ####################################################################################################
  def Resume.create_reqs(resume, req_ids, logged_employee, current_employee, comment = nil)
    if req_ids
      requirements = []
      req_ids.each do |req_id|
        requirements << Requirement.find(req_id)
      end
      req_owners_reqs = {}
      requirements.each do |requirement|
        req_owner = requirement.employee
        req_owners_reqs[req_owner] ||= []
        req_owners_reqs[req_owner] << requirement
      end

      forwarded_employees = []
      existing_employees = []
      forwarded_reqs = []
      req_owners_reqs.each do |req_owner, reqs|
        # We only consider forwards for which action has
        # not been taken, else it will not show up on
        # the forwarded page.
        old_forwards = resume.forwards.find_all { |f|
          (f.emp_forwarded_to == req_owner) &&
          (f.status == "FORWARDED")
        }
        old_reqs = []
        old_forwards.each do |f|
          old_reqs += f.requirements
        end
        new_reqs = reqs - old_reqs

        unless new_reqs.size == 0
          # if a forward for this resume exists, just add the req
          # to same forward
          if old_forwards.size > 0
            old_forwards[0].requirements += new_reqs
            old_forwards[0].save
          else
            fwd = Forward.new(:emp_forwarded_to => req_owner,
                        :emp_forwarded_by => logged_employee,
                        :resume       => resume,
                        :status       => "FORWARDED")
            fwd.save!
            fwd.requirements = new_reqs
            fwd.save
          end
          uniqid = resume.uniqid
          # Sending email
          Emailer.forward(current_employee, req_owner, resume, uniqid).deliver_now
          forwarded_employees << req_owner
          forwarded_reqs += new_reqs
        else
          existing_employees << req_owner
        end
      end
      # Adding comment
      if comment.nil?  || comment.empty? || comment == "Add Comment"
        ctype = "INTERNAL"
        comment = "No comments added while forwarding"
      else
        ctype = "USER"
      end
      if (forwarded_employees.size > 0) 
        fnames = []
        rnames = []
        forwarded_employees.each do |f| fnames << f.name end
        forwarded_reqs.each do |r| rnames << r.name end
        resume.add_resume_comment("FORWARDED TO: #{fnames.join(",")} for #{rnames.join(",")} " + comment, ctype, logged_employee)
        mesg = "You have forwarded resume to #{fnames.join(",")}"
      else
        mesg = "This resume has already been forwarded for the requirement(s)"
      end
    end
    # Set status to uninitialized so that overall status is calculated correctly
    resume.status = ""
    resume.save
    resume.update_overall_status
    mesg
  end

  def update_search_fields
    self.update_experience
    self.update_overall_status
    self.update_related_requirements
  end

  def update_experience
    years, months = self.get_current_experience
    if (self.exp_in_months != 12 * years + months)
      self.exp_in_months = 12 * years + months
      self.save
    end
  end

  def update_overall_status
    logger.info("Resume: Updating overall status from #{self.overall_status}")
    new_overall_status = self.calculate_overall_status
    if new_overall_status != self.overall_status
      logger.info("Resume: Updating overall status from #{self.overall_status} to #{new_overall_status}")
      self.overall_status = new_overall_status
      self.save
    end
  end

  def update_related_requirements
    reqs = self.forwards.inject([]) { |reqs, f|  
      reqs += f.requirements.map { |r| r.id.to_s} 
    }
    reqs += self.req_matches.map { |r| r.requirement.id.to_s }
    reqs.uniq!
    # There is only so much space for the reqs string in the db
    reqs = reqs[0..5]
    new_related_requirements = reqs.join(' ')
    if self.related_requirements != new_related_requirements
      self.related_requirements = new_related_requirements
      self.save
    end
  end

  def preferred_file
    filenames = self.resume_path
    pdf_file = nil
    docx_file = nil
    doc_file = nil
    rtf_file = nil
    odt_file = nil
    txt_file = nil
    filenames.each do |filename|
      pdf_file = filename if /(.pdf)$/.match(filename)
      pdf_file = filename if /(.PDF)$/.match(filename)
      docx_file = filename if /(.docx)$/.match(filename)
      docx_file = filename if /(.DOCX)$/.match(filename)
      doc_file = filename if /(.doc)$/.match(filename) 
      rtf_file = filename if /(.rtf)$/.match(filename) 
      odt_file = filename if /(.odt)$/.match(filename)
      txt_file = filename if /(.txt)$/.match(filename)
    end
    return pdf_file, 'application/pdf', 'pdf' if pdf_file
    return docx_file,'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'docx' if docx_file
    return doc_file, 'application/msword', 'doc' if doc_file 
    return odt_file, 'application/vnd.oasis.opendocument.text', 'odt' if odt_file 
    return rtf_file, 'application/rtf', 'rtf' if rtf_file
    return txt_file, 'text/html', 'txt' if txt_file
    return nil, nil
  end

  # Searchkick methods
  def search_data
    {
      id: id,
      name: name,
      email: email,
      phone: phone,
      qualification: qualification,
      location: location,
      preferred_location: preferred_location,
      summary: summary,
      resume_search_content: self.resume_search_content, 
      overall_status: overall_status,
      related_requirements: related_requirements,
      ctc: ctc&.to_f || 0.0,
      expected_ctc: expected_ctc&.to_f || 0.0,
      exp_in_months: exp_in_months&.to_i || 0,
      skills: skills,
      current_company: current_company,
      experience: experience,
      notice: notice&.to_i || 0,
      status: status,
      manual_status: manual_status,
      likely_to_join: likely_to_join,
      skype_id: skype_id,
      practice_head_rating: practice_head_rating,
      git_id: git_id,
      linkedin_id: linkedin_id,
      uniqid: uniqid.name,
      referral_type: referral_type,
      referral_id: referral_id,
      joining_date: joining_date,
      file_name: file_name,
      ta_owner_name: ta_owner&.name,
      created_at: created_at,
      updated_at: updated_at,
      embedding: get_embedding
    }
  end

  def should_index?
    # Only index resumes that are not deleted
    !destroyed?
  end

  # Generate and save embedding for this resume
  def generate_and_save_embedding(force:false)
    return false if self.embedding and not force
    text_to_embed = prepare_text_for_embedding
    return false if text_to_embed.blank?
    
    begin
      embedding = OpenaiUtils.generate_embedding(text_to_embed)
      return false if embedding.nil?
      
      # Save to database
      self.update(embedding: embedding.to_json)
      
      # Reindex in Elasticsearch to include the new embedding
      reindex
      
      true
    rescue => e
      Rails.logger.error "Error generating embedding for resume #{id}: #{e.message}"
      false
    end
  end

  # Retrieve embedding from database
  def get_embedding
    return nil if embedding.blank?
    
    begin
      JSON.parse(embedding)
    rescue JSON::ParserError
      Rails.logger.error "Error parsing embedding for resume #{id}"
      nil
    end
  end

private

  def expire_joined_cache
    if Rails.cache.delete('joined')
      Rails.logger.info("Cache key 'joined' successfully deleted.")
    else
      Rails.logger.warn("Cache key 'joined' does not exist.")
    end
  end

  def create_search_data(txt)
    self.resume_text_content = txt
    self.save
  end

  def resume_search_content
    search_content = ""
    search_content << "text: " + self.resume_text_content if self.resume_text_content
    search_content << " name: " + self.name if self.name
    search_content << " preferred_location: " + self.preferred_location if self.preferred_location
    search_content << " location: " + self.location if self.location
    search_content << " skills: " + self.skills if self.skills
    search_content << " current_company: " + self.current_company if self.current_company
    search_content << " overall_status: " + self.overall_status if self.overall_status
    search_content << " related_requirements: " + self.related_requirements if self.related_requirements
    search_content << " status: " + self.status if self.status
    search_content << " qualification: " + self.qualification if self.qualification
    search_content << " email: " + self.email if self.email
    search_content << " phone: " + self.phone if self.phone
    search_content << " summary: " + self.summary if self.summary

    self.forwards.each do |fwd|
      search_content << " " + fwd.status
    end
    self.req_matches.each do |match|
      search_content << " " + match.status
    end
    self.comments.each do |comment|
      search_content << " " + comment.comment
    end
    search_content
  end

  def find_agency_by_name(iname)
    return Agency.find_by_name(iname);
  end

  def remove_whitespaces
    self.phone.gsub!(/\s+/, "")
  end

  # Prepare text for embedding generation
  def prepare_text_for_embedding
    # Combine relevant fields for embedding
    text_parts = []
    
    text_parts << "Resume Qualification: #{qualification}" if qualification.present?
    text_parts << "Resume Skills: #{skills}" if skills.present?
    text_parts << "Resume Summary: #{summary}" if summary.present?
    
    # Add resume text content (the main content)
    if resume_text_content.present?
      # Truncate if too long to avoid token limits
      content = resume_text_content.length > 4000 ? resume_text_content[0..4000] + "..." : resume_text_content
      text_parts << "Resume Content: #{content}"
    end
    
    # Add experience information
    if exp_in_months.present?
      years = (exp_in_months.to_f / 12).round(1)
      text_parts << "Resume Experience: #{years} years (#{exp_in_months} months)"
    end
    
    # Join all parts with spaces and clean up
    text_parts.compact.join(" ").strip
  end

  # Class method for KNN similarity search with optional filters
  def self.similar_resumes(embedding_vector, where_conditions: [], exclude_terms: [], distance: "cosine", page: 1, per_page:20)
    search(knn: { field: :embedding, vector: embedding_vector, distance: distance},
           where: where_conditions,
           exclude: exclude_terms,
           page: page,
           per_page: per_page)
  end

end
