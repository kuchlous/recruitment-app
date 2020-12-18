class Resume < ActiveRecord::Base
  require 'rubygems'
  require 'sanitize'

  belongs_to               :uniqid
  belongs_to               :employee
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

  # Figure out why this is used here
  # validate_on_create  :email
  # validate_on_create  :phone

  # Uniqueness stuff
  validates_uniqueness_of :email
  validates_uniqueness_of :phone

  # Stuff which should be done exactly before validation
  before_validation :remove_whitespaces

  after_save :update_overall_status

  # Format stuff
  validates_format_of      :email, :with => /([\w]+)@([\w]+)\./
  
  # validate_on_create       :check_for_valid_attributes

  # Appending date-time to file names
  current_time      = Time.now
  current_date      = Time.now
  $date_time_suffix = current_time.strftime("%d-%b-%Y-%H-%M-%S")
  $tmp_status_file  = APP_CONFIG['status_file']   + "-" + $date_time_suffix + ".xls"
  $tmp_xls          = APP_CONFIG['xls_temp_file'] + "-" + $date_time_suffix 
  $tmp_zip          = APP_CONFIG['zip_temp_file'] + "-" + $date_time_suffix
  $tmp_file         = APP_CONFIG['temp_file']
  $upload_dir       = APP_CONFIG['upload_directory']
  $tmp_directory    = APP_CONFIG['temp_directory']
  $tmp_resumes_directory  = $tmp_directory + '/' + APP_CONFIG['temp_resumes']

  def rejected?
    return "REJECTED" == self.status if self.status != ""
    return false if (self.forwards.size == 0 && self.req_matches.size == 0)  # new resume

    nreqs = ReqMatch.count_by_sql("select COUNT(*) FROM req_matches WHERE req_matches.resume_id = #{self.id} AND req_matches.status != \"REJECTED\"")
    return false if nreqs != 0

    nforwards = ReqMatch.count_by_sql("select COUNT(*) FROM forwards where forwards.resume_id = #{self.id} AND forwards.status != \"REJECTED\" AND forwards.status != \"ACTION TAKEN\" ")
    return false if nforwards != 0

    return true
  end

  def req_for_decision
    req_matches = self.req_matches
    return nil if req_matches.size == 0
    return req_matches.first.requirement if req_matches.size == 1
    # Go over req_matches in latest updated to previous
    req_matches = req_matches.sort_by {|r| r.updated_at}.reverse
    req_matches.each do |req_match|
      if req_match.status == "SELECTED" || req_match.status == "SCHEDULED"
        return req_match.requirement
      end
    end
    return nil
  end

  def resume_overall_status
    if self.status   != ""
      return self.status.titleize
    end

    self.overall_status
  end

  @@STATUS_MAP = {
    "JOINING" => "Joining Date Given",
    "OFFERED" => "Offered",
    "YTO" => "Yet To Offer",
    "HAC" => "HAC",
    "ENG_SELECT" => "Engg. Select",
    "HOLD" => "On Hold",
    "SCHEDULED" => "Interview Scheduled",
    "SHORTLISTED" => "Shortlisted",
    "FORWARDED" => "Forwarded",
    "REJECTED" => "Rejected",
    "NEW" => "New"
  }

  def self.req_match_status_to_resume_status(req_match_status)
    @@STATUS_MAP[req_match_status]
  end

  def calculate_overall_status
    status_array = []

    self.req_matches.each do |match|
      status_array << match.status
    end

    self.forwards.each do |fwd|
      if (fwd.status != "ACTION TAKEN")
        status_array << fwd.status
      end
    end

    reject_array = Array.new(status_array.size, "REJECTED")
    if status_array.include?("JOINING")
      return "Joining Date Given"
    elsif status_array.include?("OFFERED")
      return "Offered"
    elsif status_array.include?("YTO")
      return "Yet To Offer"
    elsif status_array.include?("HAC")
      return "HAC"
    elsif status_array.include?("ENG_SELECT")
      return "Engg. Select"
    elsif status_array.include?("HOLD")
      return "On Hold"
    elsif status_array.include?("SCHEDULED")
      return "Interview Scheduled"
    elsif status_array.include?("SHORTLISTED")
      return "Shortlisted"
    elsif status_array.include?("FORWARDED")
      return "Forwarded"
    elsif status_array.size == 0
      return "New"
    elsif status_array.eql?(reject_array)
      return "Rejected"
    else
    end
  end

  def Resume.get_resume_statuses
    ["Any", "Joining Date Given", "Offered", "On Hold", "Selected", "Interview Scheduled", "Shortlisted", "Forwarded", "New", "Rejected", "FUTURE", "HAC", "N Accepted", "Not Joined"]
  end

  # This gets called from the constructor after the call to 
  # Resume.new(params[:resume])because we have a upload_resume
  # in the params list.
  def upload_resume=(upload_field)
    unless upload_field.nil?
      tempfile = Tempfile.new("resume_tmp", :encoding => 'ascii-8bit')
      tempfile.write(upload_field.read)
      tempfile.close
      ext            = File.extname(upload_field.original_filename)
      # Create the directory to hold the resumes
      FileUtils.mkdir_p($tmp_directory)
      fullpathname      = File.join($tmp_directory, $tmp_file) + ext
      tempfile = File.open(tempfile.path)
      file_type = Resume.read_upload_write_tmp_file(fullpathname, tempfile)
      logger.info("Uploaded file of type #{file_type}")
      add_html_txt_and_search(ext, file_type)
      @file_type = file_type
    else
      @file_type = "UNDEFINED"
    end
  end

  def move_temp_file_to_upload_directory(original_filename)
    filenames = `ls #{$tmp_directory}/#{$tmp_file}.*`.split("\n")
    filenames.each do |filename|
      upload_dir = Rails.root.join(APP_CONFIG['upload_directory']).join(self.id.to_s)
      Dir.mkdir(upload_dir) if not Dir.exist?(upload_dir)
      `mv -f #{filename} '#{upload_dir}/#{original_filename}'`
    end
    # Removing content.xml file
    delete_temp_files($tmp_directory, "customXml")
    delete_temp_files($tmp_directory, "word")
    delete_temp_files($tmp_directory, "_rels")
    delete_temp_files($tmp_directory, "docProps")
    delete_temp_files($tmp_directory, "*.xml")
    delete_temp_files($tmp_directory, "mimetype")
  end

  def resume_path
    upload_dir = Rails.root.join(APP_CONFIG['upload_directory']).join(self.id.to_s)
    file_names = `ls #{upload_dir}/*`.split("\n")
  end

  def cleanup_update_resume_data(upload_field)
    upload_dir = Rails.root.join(APP_CONFIG['upload_directory']).join(self.id.to_s)
    # Uploading resume file to upload directory
    original_filename = upload_field['upload_resume'].original_filename
    ext               = File.extname(upload_field['upload_resume'].original_filename)
    fullpathname      = upload_dir.join(original_filename)
    # Writing to file in upload directory
    file_type = Resume.read_upload_write_tmp_file(fullpathname, upload_field['upload_resume'])
    add_html_txt_and_search(ext, file_type)

    # Move from temp directory to upload directory
    self.move_temp_file_to_upload_directory(original_filename)
  end

  def add_resume_comment(comment, ctype, employee)
    Comment.new(:comment     => comment,
                :resume_id   => self.id,
                :leave_id    => 0,
                :ctype       => ctype,
                :employee_id => employee.id).save!
  end

  def get_resume_req_matches(employee)
    matches_array = []
    matches       = self.req_matches.find_all { |r|
			employee.is_HR?    ||
      employee.is_ADMIN? || employee.is_GM? ||
      r.requirement.employee == employee || r.requirement.eng_lead == employee
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

  def add_html_txt_and_search(ext, file_type)
    file_fullpath_without_ext = $tmp_directory + '/' + $tmp_file
    fullpathname              = file_fullpath_without_ext + ext
    if file_type.match("msword")
      txt = `antiword #{fullpathname} 2>& 1`
      # Save as txt file
      File.open(file_fullpath_without_ext + '.txt', "w") { |f| f << txt }
    elsif  file_type == "text/html"
      # This is a html hiding as a doc
      txt = File.read(fullpathname)
      # Save as html
      File.open(file_fullpath_without_ext + '.html', "w") { |f| f << txt }
    elsif file_type == "text/rtf"
      # This is a rich text file
      txt = convert_rtf_to_txt(fullpathname)
      File.open(file_fullpath_without_ext + '.txt', "w") { |f| f << txt }
    elsif file_type == "application/pdf"
      txt = `pdftotext -eol unix -nopgbrk #{fullpathname} 2>& 1`
    elsif file_type == "application/x-zip"
      # Unzipping the odt file
      # with excluding all files except content.xml
      unzipped_files = `unzip #{fullpathname} -x meta.xml mimetype settings.xml styles.xml -d #{$tmp_directory}`

      if File.exists?("#{$tmp_directory}/Configurations2")
        # Deleting junk files
        delete_temp_files($tmp_directory, "Configurations2")
        delete_temp_files($tmp_directory, "META-INF")
        delete_temp_files($tmp_directory, "Thumbnails")

        txt = Sanitize.clean(File.read("#{$tmp_directory}/content.xml"))
        # Save as txt file
        File.open(file_fullpath_without_ext + '.txt', "w") { |f| f << txt }
      else
        # Deleting junk files
        delete_temp_files($tmp_directory, "word")
        delete_temp_files($tmp_directory, "_rels")
        delete_temp_files($tmp_directory, "docProps")
        delete_temp_files($tmp_directory, "*.xml")
        delete_temp_files($tmp_directory, "mimetype")
        delete_temp_files($tmp_directory, "customXml")

        zipout = `unzip #{fullpathname} -x -d #{$tmp_directory}`
        logger.info("#{zipout}")
        if File.exists?("#{$tmp_directory}/word/document.xml")
          txt = Sanitize.clean(File.read("#{$tmp_directory}/word/document.xml"))
          # Save as txt file
          File.open(file_fullpath_without_ext + '.txt', "w") { |f| f << txt }

          # Deleting junk files
          delete_temp_files($tmp_directory, "word")
          delete_temp_files($tmp_directory, "_rels")
          delete_temp_files($tmp_directory, "docProps")
          delete_temp_files($tmp_directory, "*.xml")
          delete_temp_files($tmp_directory, "customXml")
        end
      end
    end

    create_search_data
  end

  def Resume.read_upload_write_tmp_file(path, file)
    File.open(path, "w") { |f| f.write(file.read.force_encoding("UTF-8")) }
    file_type         = `file -ib '#{path}'`.gsub(/\n/,"")
    return file_type
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
      # @file_type = `file -ib #{zip_temp_file_name}`.gsub(/\n/,"")
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
    requirement = find_requirement_by_name(requirement_name)
    if requirement_name && requirement.nil?
      msg = "Requirement name #{requirement_name} not found in our database"
      errors.add(msg)
      return false
    end

    vendor = find_agency_by_name(vendor_name)
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
    @file_type = `file -ib #{tmp_file}`.gsub(/\n/,"")
    if self.save
      add_html_txt_and_search(ext, @file_type)
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
    new_overall_status = self.calculate_overall_status
    if new_overall_status != self.overall_status
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
      docx_file = filename if /(.docx)$/.match(filename)
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

private
  def convert_rtf_to_txt(filename)
    txt = `unrtf -n --text -P /usr/local/lib/unrtf/ #{filename} 2>& 1`
  end

  def check_for_valid_attributes
    file_type_simple = ""
    file_type_simple = @file_type.gsub(/;.*/, "") if @file_type
    if file_type_simple == "UNDEFINED"
      errors.add("Empty Resume")
    elsif ( ![ "application/pdf", "text/plain", "text/html", "text/rtf", "application/msword",
               "application/msword application/msword", "application/msword", "application/x-zip", "application/zip" ].include?(file_type_simple))
      errors.add("Unknown filetype. Please provide file types of .doc, .docx, .pdf, .rtf, .html and .txt")
    end
  end

  def save_as_html_text(fullpathname, file_fullpath_without_ext, file_type)
    if (file_type == "text/html")
      # This is a html hiding as a doc
      txt = File.read(fullpathname)
      # Save as html
      File.open(file_fullpath_without_ext + '.html', "w") { |f| f << txt }
    elsif (file_type == "text/rtf")
      # This is a rich text file
      txt = convert_rtf_to_txt(fullpathname)
      File.open(file_fullpath_without_ext + '.txt', "w") { |f| f << txt }
    else
      txt = `antiword #{fullpathname} 2>& 1`
      # Save as txt file
      File.open(file_fullpath_without_ext + '.txt', "w") { |f| f << txt }
    end
  end

  def create_search_data
    filenames     = `ls #{$tmp_directory}/#{$tmp_file}.*`.split("\n")
    txtfile       = ""
    htmlfile      = ""
    txt = ""
    filenames.each do |filename|
      if /.txt$/.match(filename)
        txt = File.read(filename)
        break
      elsif /.html$/.match(filename)
        txt = Sanitize.clean(File.read(filename))
        break
      end
    end

    self.search_data = txt

    # Adding forwards status to ferret
    self.forwards.each do |fwd|
      self.search_data << " " + fwd.status
    end
    # Adding req_matches status to ferret
    self.req_matches.each do |match|
      self.search_data << " " + match.status
    end
    # Adding comments to ferret
    self.comments.each do |comment|
      self.search_data << " " + comment.comment
    end
  end

  def delete_temp_files(dir, name)
    `rm -rf #{dir}/#{name}`
  end

  def find_requirement_by_name(iname)
    return Requirement.find_by_name(iname)
  end

  def find_agency_by_name(iname)
    return Agency.find_by_name(iname);
  end

  def remove_whitespaces
    self.phone.gsub!(/\s+/, "")
  end

end
