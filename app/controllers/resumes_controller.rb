class ResumesController < ApplicationController
  require 'spreadsheet'

  # before_filter :check_for_login, :except => [ :get_summary_by_id ]
  before_action :check_for_HR_or_ADMIN_or_REQMANAGER_or_PM_or_BD,    :only => [ :hold,           :offered,
                                                                          :edit,           :recent,
                                                                          :joined,         :rejected,
                                                                          :shortlisted,    :forwarded,
                                                                          :new_resumes,    :export_as_xls,  
                                                                          :export_as_xls_requirement, 
                                                                          :export_as_xls_all_uploaded_resumes, 
                                                                          :manager_index, 
                                                                          :manager_interviews_status ]


  # caches_action :joined, :layout => false
  # cache_sweeper :resumes_sweeper

  ####################################################################################################
  # FUNCTIONS   : new, edit, create, update, show                                                    #
  # DESCRIPTION : These functions are common operations on resume. Used Scaffold Type                #
  #               Delete is not there because we do not allow to delete a resume.                    #
  #               Also deleting an resume can be done only by calling delete_resume_details from     #
  #               console                                                                            #
  ####################################################################################################
  def new
    @resume = Resume.new
  end

  def show
    unless params[:id].nil?
      @resume         = Uniqid.find_by_name(params[:id]).resume
      @overall_status = @resume.resume_overall_status
      if @overall_status == "N_ACCEPTED"
        @overall_status  = "Not Accepted"
      end
      @comments       = @resume.comments
      @feedbacks      = @resume.feedbacks
      @messages       = @resume.messages
    else
      flash[:notice]  = "No details available for this resume"
      redirect_back(fallback_location: root_path)
    end
  end

  def new_resumes
    if params[:mine]
      employee = get_current_employee
      resumes = Resume.where("referral_type = ? AND referral_id = ? AND status = ? AND nforwards = ? AND nreq_matches = ?", "EMPLOYEE", employee.id, "", 0, 0)
    else
      resumes = Resume.where("status = ? AND nforwards = ? AND nreq_matches = ?", "", 0, 0)
    end
    @resumes      = resumes
  end

  def show_by_id
    unless params[:id].nil?
      resume         = Resume.find_by_id(params[:id])
      unless resume.nil?
	redirect_to :controller => "resumes", :action => "show", :id => resume.uniqid.name
      else
        flash[:notice]  = "No details available for this resume"
        redirect_back(fallback_location: root_path)
      end
    else
      flash[:notice]  = "No details available for this resume"
      redirect_back(fallback_location: root_path)
    end
  end

  def get_summary_by_id
    unless params[:id].nil?
      @resume         = Resume.find_by_id(params[:id])
      unless @resume.nil?
        render "summary_json", :layout => false
      else
	render :text => "No such resume", :status => 403
        return
      end
    else
      render :text => "Empty resume id", :status => 403
      return
    end
  end

  def edit
    @resume = Resume.find(params[:id])
  end

  def create
    @resume    = Resume.new(params.require(:resume).permit!)
    flash_mesg = status = ""
    if params[:resume][:referral_type] == "DIRECT"
      @resume.referral_id   = 0
    end
    if params[:experience_years] &&
       params[:experience_months]
      @resume.experience = params[:experience_years] + "-" + params[:experience_months]
    end
    @resume.employee   = get_current_employee
    @resume.summary    = "UPLOADED without comments." if params[:resume][:summary].nil?
    @resume.uniqid     = Uniqid.generate_unique_id(@resume.name, @resume)
    respond_to do |format|
      if @resume.save
        # Adding comment while uploading resume
        comment = "UPLOADING: #{get_logged_employee.name} uploaded resume on #{@resume.created_at.strftime('%b %d, %Y')}."
        @resume.add_resume_comment(comment, "INTERNAL", get_logged_employee)
        @resume.move_temp_file_to_upload_directory
        email_for_upload(@resume)

        # If reqs are selected
        if (params[:requirement_name])
          Resume.create_reqs(@resume, params[:requirement_name], get_logged_employee, get_current_employee)
          flash_mesg = "You have successfully uploaded the resume and it has been forwarded to the owners of the requirements that you selected"
        else
          flash_mesg = "You have successfully uploaded resume"
        end
        flash[:notice] = flash_mesg
        format.html { redirect_to :action => "new" }
      else
        @resume.errors.each { |mesg|
           logger.info(mesg)
        }
        format.html { render "new" }
      end
    end
  end

  def update
    @resume = Resume.find(params[:id])
    changed_referral = params[:resume][:referral_id] != @resume.referral_id ?
                       true : false
    if params[:experience_years] &&
       params[:experience_months]
      @resume.experience = params[:experience_years] + "-" + params[:experience_months]
    end
    # TODO:Change to strong parameters 
    if @resume.update_attributes(params.require(:resume).permit!)
      if params[:resume][:upload_resume]
        @resume.cleanup_update_resume_data(params[:resume])
      end
      # Adding comments while editing resume details
      if params[:resumes][:comments].nil? ||
         params[:resumes][:comments].empty?
        comment = "No comments added while updating resume"
        ctype   = "INTERNAL"
      else
        comment = params[:resumes][:comments]
        ctype   = "USER"
      end
      comment   = "UPDATE RESUME: " + comment
      # Adding Comments
      @resume.add_resume_comment(comment, ctype, get_logged_employee)
      
      email_for_upload(@resume) if changed_referral

      flash[:notice]  = "You have successfully updated details of #{@resume.name}"
      redirect_to :action => "show", :id => @resume.uniqid.name
    else
      @resume.errors.full_messages { |mesg|
        logger.info(mesg)
      }
      render :action => "edit"
    end
  end

  def upload_xls
    @resume = Resume.new
  end

  def process_xls_and_zipped_resumes
    if params[:resume].nil?
      flash[:notice] = "Please provide both excel file and zipped file for resumes."
      redirect_back(fallback_location: root_path)
    else
      status_file, message = Resume.upload_xls(params[:resume][:upload_xls], params[:resume][:upload_zipped_resume],
                             get_logged_employee, get_current_employee)
      if (message.nil?)
        send_file(status_file)
      elsif (/missing/.match(message))
        flash[:notice] = "Please provide both excel file and zipped file for resumes."
        redirect_back(fallback_location: root_path)
      elsif (/excel/.match(message))
        flash[:notice] = "Please provide only excel file"
        redirect_back(fallback_location: root_path)
      elsif (/zip/.match(message))
        flash[:notice] = "Please provide only zip file"
        redirect_back(fallback_location: root_path)
      elsif (/No data/.match(message))
        flash[:notice] = "Excel file does not have any data inside it. Please try uploading correct excel file."
        redirect_back(fallback_location: root_path)
      end
    end
  end

  ####################################################################################################
  # FUNCTIONS   : manager_index,  manager_shortlisted, manager_rejected, manager_hold                #
  #               manager_joined, manager_offered                                                    #
  # DESCRIPTION : Manager functions which are used by the req managers.                              #
  #               These functions are used to display all reqmatches of the requirements which       #
  #               the manager already have.                                                           #
  ####################################################################################################
  def manager_index
    @status               = "FORWARDED"
    @is_req_match         = 0
    @after_shortlist_page = false
    @forwards = get_matches(@status, true)
  end

  def manager_shortlisted
    @status               = "SHORTLISTED"
    @is_req_match         = 1
    @after_shortlist_page = true
    @forwards = get_matches(@status, true)
    render "manager_index"
  end

  def manager_rejected
    @status               = "REJECTED"
    @is_req_match         = 1
    @after_shortlist_page = true
    @forwards = get_matches(@status, false)
    @forwards = @forwards.paginate(:page => params[:page], :per_page => 100)
    render "manager_index"
  end

  def manager_hold
    @status           = "HOLD"
    @join_on_req_page = @offer_on_req_page = 0
    @matches          = ReqMatch.find_employee_requirements_req_matches(get_current_employee, true)
    @matches          = @matches.find_all { |m|
      m.status       == @status
    }

  end

  def manager_eng_select
    @status  = "ENG_SELECT"
    @matches = ReqMatch.find_employee_requirements_req_matches(get_current_employee, false)
    @matches = @matches.find_all { |m|
       m.status == @status
    }
    render "manager_yto"
  end

  def manager_hac
    @status  = "HAC"
    @matches = ReqMatch.find_employee_requirements_req_matches(get_current_employee, false)
    @matches = @matches.find_all { |m|
       m.status == @status
    }
    render "manager_yto"
  end

  def manager_yto
    @status  = "YTO"
    @matches = ReqMatch.find_employee_requirements_req_matches(get_current_employee, false)
    @matches = @matches.find_all { |m|
       m.status == @status
    }
  end

  def manager_joined
    @status           = "JOINING"
    @join_on_req_page = @offer_on_req_page = 0
    @matches          = ReqMatch.find_employee_requirements_req_matches(get_current_employee, false)
    @joined_matches   = @matches.find_all { |m|
      m.status       == @status &&
      m.resume.resume_overall_status == "Joined"
    }
    @joining_matches = @matches.find_all { |m|
      m.status       == @status &&
      m.resume.resume_overall_status == "Joining Date Given"
    }
  end

  def manager_offered
    @status  = "OFFERED"
    @join_on_req_page = @offer_on_req_page = 0
    @matches = ReqMatch.find_employee_requirements_req_matches(get_current_employee, false)
    @matches = @matches.find_all { |m|
       m.status == @status
    }
  end

  ####################################################################################################
  # FUNCTIONS   : forwarded, shortlisted, rejected, hold, joined, offered, future                    #
  # DESCRIPTION : Hr functions which are used by the ADMIN/HR.                                       #
  #               These functions are used when HR/ADMIN wants to see all the reqmatches of specified#
  #               status.                                                                            #
  ####################################################################################################
  def forwarded
    @status        = "FORWARDED"
    @is_req_match  = 0
    @after_shortlist_page = false
    @forwards = get_hr_matches(@status)    
    if params[:mine]
      @forwards = @forwards.find_all{|f| f.resume.referral_type == "EMPLOYEE" && f.resume.referral_id == get_current_employee.id}
    end
    render "manager_index"
  end

  def shortlisted
    @status        = "SHORTLISTED"
    @is_req_match  = 1
    @after_shortlist_page = true
    @forwards = get_hr_matches(@status)
    if params[:mine]
      @forwards = @forwards.find_all{|f| f.resume.referral_type == "EMPLOYEE" && f.resume.referral_id == get_current_employee.id}
    end
               
    render "manager_index"
  end

  def rejected
    @status         = "REJECTED"
    @row_id_prefix  = "rejected_resume_row"
    @is_req_match   = 1
    @after_shortlist_page = true
    @forwards = get_hr_matches_cached(@status)
    if params[:mine]
      @forwards = @forwards.find_all{|f| f.resume.referral_type == "EMPLOYEE" && f.resume.referral_id == get_current_employee.id}
    end
    @forwards = @forwards.paginate(:page => params[:page], :per_page => 100)
    render "manager_index"
  end

  def hold
    @status           = "HOLD"
    @join_on_req_page = @offer_on_req_page = 0
    @matches          = get_all_req_matches_of_status(@status)
    if params[:mine]
      @matches = @matches.find_all{|f| f.resume.referral_type == "EMPLOYEE" && f.resume.referral_id == get_current_employee.id}
    end
  end

  def eng_select
    @status           = "ENG_SELECT"
    @matches          = get_all_req_matches_of_status(@status)
    if params[:mine]
      @matches = @matches.find_all{|f| f.resume.referral_type == "EMPLOYEE" && f.resume.referral_id == get_current_employee.id}
    end
    render "yto"
  end

  def hac
    @status           = "HAC"
    @matches          = get_all_req_matches_of_status(@status)
    if params[:mine]
      @matches = @matches.find_all{|f| f.resume.referral_type == "EMPLOYEE" && f.resume.referral_id == get_current_employee.id}
    end
    render "yto"
  end

  def yto
    @status           = "YTO"
    @matches          = get_all_req_matches_of_status(@status)
    if params[:mine]
      @matches = @matches.find_all{|f| f.resume.referral_type == "EMPLOYEE" && f.resume.referral_id == get_current_employee.id}
    end
  end

  def find_joining_resumes
    matches = ReqMatch.find_by_sql("SELECT * FROM req_matches INNER JOIN resumes ON resumes.id = req_matches.resume_id WHERE req_matches.status = \"JOINING\" AND resumes.status != \"JOINED\" AND resumes.joining_date > \"#{(Date.today - 365).to_s}\" ORDER BY resumes.joining_date")

    matches = matches.find_all { |r|
                r.resume.resume_overall_status == "Joining Date Given"
              }
    joined_resumes     = Resume.find_by_sql("SELECT * FROM resumes WHERE resumes.status = \"JOINED\" ORDER BY joining_date")
    not_joined_resumes = Resume.find_by_sql("SELECT * FROM resumes WHERE resumes.status = \"NOT JOINED\" ORDER BY joining_date")
    if params[:mine]
      matches = matches.find_all{|f| f.resume.referral_type == "EMPLOYEE" && f.resume.referral_id == get_current_employee.id}
      joined_resumes = joined_resumes.find_all{|r| r.referral_type == "EMPLOYEE" && r.referral_id == get_current_employee.id} 
      not_joined_resumes = not_joined_resumes.find_all{|r| r.referral_type == "EMPLOYEE" && r.referral_id == get_current_employee.id} 
    end
    [matches, joined_resumes, not_joined_resumes]
  end


  def find_joining_resumes_old
    matches = get_all_req_matches_of_status("JOINING").find_all { |r|
                r.resume.resume_overall_status == "Joining Date Given"
              }
    matches = matches.sort_by { |m| [m.resume.joining_date ? m.resume.joining_date : Date.today, 
                                     m.requirement.name] }

    joined_resumes   = Resume.find_all_by_status("JOINED")
    joined_resumes = joined_resumes.sort_by { |r| [!r.joining_date.nil? ?
                                                      r.joining_date : 
                                                      Date.today
                                                    ] 
                                              }

    not_joined_resumes = Resume.find_all_by_status("NOT JOINED")
    not_joined_resumes = not_joined_resumes.sort_by { 
                            |r| [!r.joining_date.nil? ? 
                                    r.joining_date : Date.today 
                                ] 
                          }
    [matches, joined_resumes, not_joined_resumes]
  end

  def fill_months_table(months_table, full_table, type)
    month_index = 0
    full_table.each do |r|
      r_date = r.joining_date 
      r_year = r_date.year
      r_month = r_date.month
      while (r_year != months_table[month_index][:year] ||
             r_month != months_table[month_index][:month])
        month_index += 1
      end
      months_table[month_index][type] += 1
    end
  end

  def start_of_month(date)
    Date.new(date.year, date.month, 1)
  end

  def end_of_month(date)
    Date.new(date.year, date.month, Time::days_in_month(date.month, date.year))
  end

  def filter_by_joining_date(resumes, start_date, end_date)
    resumes.find_all { |r| 
      r.joining_date && r.joining_date >= start_date && r.joining_date <= end_date
    }
  end

  def create_months_table(joining_matches, joined, not_joined)
    start_date = start_of_month(Date.today - 360)
    end_date = end_of_month(Date.today + 90)

    # Normalize to 0 .. 11
    start_month = start_date.month - 1
    year = start_date.year
    months_table = []
    0.upto 15 do |i|
      months_table[i] = {}
      # Add '1' to get back 1 .. 12
      month = ((start_month + i) % 12) + 1
      months_table[i][:month] = month
      months_table[i][:year] = year
      months_table[i][:joining] = 0
      months_table[i][:joined] = 0
      months_table[i][:not_joined] = 0
      if (month == 12)
        year = year + 1
      end
    end

    joining = []
    joining_matches.each do |m|
      joining << m.resume
    end

    fill_months_table(months_table, filter_by_joining_date(joining, start_date, end_date), :joining)
    fill_months_table(months_table, filter_by_joining_date(joined, start_date, end_date), :joined)
    fill_months_table(months_table, filter_by_joining_date(not_joined, start_date, end_date), :not_joined)

    months_table
  end

  def find_offered_resumes
    offered_comments = Comment.all.find_all {|c| c.comment.include?("OFFERED") }
    sorted_offered_comments = offered_comments.sort_by { |c| [c.created_at] }
    sorted_offered_comments.uniq { |c| c.resume }
  end

  def joined
    @status             = "JOINING"
    @join_on_req_page   = @offer_on_req_page = 0
    @matches, joined_resumes, not_joined_resumes = find_joining_resumes
    @months_table       = create_months_table(@matches, joined_resumes, not_joined_resumes)
    @joined_resumes     = get_current_quarter_resumes("JOINED")
    @not_joined_resumes = get_current_quarter_resumes("NOT JOINED")
    @offered_comments   = get_current_quarter_resumes_for_offered
    @not_accepted_comments = get_quarterly_comments_not_accepted_new(Date.today)
  end

  def offered
    @status           = "OFFERED"
    @join_on_req_page = @offer_on_req_page = 0
    @matches          = get_all_req_matches_of_status(@status)
    @matches          = @matches.find_all { |m|
      m.resume.status != "N_ACCEPTED"
    }
    if params[:mine]
      @matches = @matches.find_all{|f| f.resume.referral_type == "EMPLOYEE" && f.resume.referral_id == get_current_employee.id}
    end
  end

  def future
    @status           = "FUTURE"
    @resumes          = Resume.all.find_all { |r|
      r.status == "FUTURE" ||
      r.status == "N_ACCEPTED"
    }
  end

  ####################################################################################################
  # FUNCTIONS   : move_to_future, mark_active, reject_all_forwards_req_matches, mark_not_accepted    #
  # DESCRIPTION : These are the functions used to apply status on resume.                            #
  #              . Will move resume to Future list.                                                  #
  #              . Reject all forwards/reqmatches.                                                   #
  #              . Mark not accepted if we offered someone but he'll not accept.                     #
  #              . Will delete status of resume(If any resume has status as future then              #
  #              . mark active method will set the status as empty.                                  #
  ####################################################################################################
  def move_to_future
    resume      = Resume.find(params[:resume_id])
    resume.update_attributes!(:status => "FUTURE")

    # Adding Comments
    resume.add_resume_comment("FUTURE LIST: Moving to future list", "INTERNAL", get_current_employee)

    flash[:notice] = "You have successfully moved #{resume.name} into future list"

    redirect_back(fallback_location: root_path)
  end

  ####################################################################################################
  # FUNCTIONS   : my_resumes                                                                         #
  # DESCRIPTION : Gets all resumes which are uploaded by employee(HR)                                #
  ####################################################################################################
  def my_resumes
   @employee = params[:id]     ? Employee.find(params[:id]) : get_current_employee
   @status   = params[:status] ? params[:status]            : "New"
   if @employee.provides_visibility_to?(get_current_employee)
     if @employee.is_HR?
       resumes  = @employee.resumes
       unless @status == "Joining Date Given"
         @resumes = resumes.find_all { |r| r.resume_overall_status == @status }
       else
         @resumes = resumes.find_all { |r| r.resume_overall_status == @status   || r.resume_overall_status == "Joined"  ||
                                           r.resume_overall_status == "Not Joined" }
       end
     else
       @resumes = get_employee_referred_resumes(@employee)
       @status  = "Referral"
     end
     @resumes = sort_resumes_by_date(@resumes)
   else
     flash[:notice] = "You are not authorised to access this page."
     redirect_to :controller => "home", :action => "actions_page"
   end
  end

  ####################################################################################################
  # FUNCTIONS   : recent_resumes                                                                     #
  # DESCRIPTION : Gets all resumes which are uploaded by (HR) within last 2 weeks                    #
  ####################################################################################################
  def recent
    employee    = get_current_employee
    @end_date   = Date.today
    @start_date = @end_date - 2.weeks
    if employee.provides_visibility_to?(get_logged_employee) && employee.is_HR?
      @resumes  = employee.resumes.find_all { |r|
                    r.change_date >= @start_date
                  }
      if params[:all]
        @resumes  = Resume.all.find_all { |r|
                      r.created_at >= @start_date
                    }
      else 
        @employee = get_current_employee
        @resumes  = @employee.resumes.find_all { |r|
                      r.created_at >= @start_date
                    }
      end
      @resumes = sort_resumes_by_date(@resumes)
    else
      flash[:notice] = "You are not authorised to access this page."
      redirect_to :controller => "home", :action => "actions_page"
    end
  end

  # TODO: Resumes are not found for end date
  def find_resume_within_given_dates
    employee = get_current_employee
    if employee.provides_visibility_to?(get_logged_employee) && employee.is_HR?
      if params[:recent] && ( params[:recent][:sdate] != "" && params[:recent][:edate] != "" )
        @start_date  = params[:recent][:sdate]
        @end_date    = params[:recent][:edate]
        @resumes    = employee.resumes.find_all { |r|
                        r.change_date >= date_in_database_format(@start_date) &&
                        r.change_date <= date_in_database_format(@end_date)
                      }
        @resumes    = sort_resumes_by_date(@resumes)
        render "resumes/recent.html.erb"
      else
        flash[:notice] = "Please select start date and end date"
        redirect_to :controller => "resumes", :action => "recent"
      end
    else
      flash[:notice] = "You are not authorised to access this page."
      redirect_to :controller => "home", :action => "actions_page"
    end
  end

  def mark_active
    resume      = Resume.find(params[:resume_id])
    resume.update_attributes!(:status => "")

    # Adding Comments
    resume.add_resume_comment("MARK ACTIVE: Setting resume status as empty for further processing", "INTERNAL", get_current_employee)
    flash[:notice] = "You have successfully activated #{resume.name} for processing"
    redirect_back(fallback_location: root_path)
  end

  def send_for_eng_decision
    resume      = Resume.find(params[:resume_id])
    requirement = resume.req_for_decision
    if !requirement
      flash[:notice] = "No matching requirement found for #{resume.name}"
      redirect_back(fallback_location: root_path)
    end
    if !requirement.ta_lead
      flash[:notice] = "No TA lead found for requirement #{requirement.name}"
      redirect_back(fallback_location: root_path)
    end

    email_for_decision(resume, requirement, true, nil)

    resume.add_resume_comment("SENT FOR DECISION: Sending resume for engineering decision", "INTERNAL", get_current_employee)
    flash[:notice] = "You have successfully sent #{resume.name} to #{requirement.employee.name} for engineering decision, req: #{requirement.name}"
    redirect_back(fallback_location: root_path)
  end

  def send_for_decision
    resume      = Resume.find(params[:resume_id])
    requirement = resume.req_for_decision
    if !requirement
      flash[:notice] = "No matching requirement found for #{resume.name}"
      redirect_back(fallback_location: root_path)
    end

    email_for_decision(resume, requirement, false, nil)

    resume.add_resume_comment("SENT FOR DECISION: Sending resume for decision", "INTERNAL", get_current_employee)
    flash[:notice] = "You have successfully sent #{resume.name} to #{requirement.employee.gm.name} for decision, req: #{requirement.name}"
    redirect_back(fallback_location: root_path)
  end

  def reject_all_forwards_req_matches
    resume      = Resume.find(params[:resume_id])
    resume.forwards.each do |f|
      f.update_attributes!(:status => "REJECTED")
    end
    resume.req_matches.each do |m|
      m.update_attributes!(:status => "REJECTED")
    end

    # Adding Comments
    resume.add_resume_comment("REJECT ALL: Rejecting all forward/requirement matches.", "INTERNAL", get_current_employee)

    flash[:notice] = "You have successfully rejected all forwards/req matches associated to this resume"
    redirect_back(fallback_location: root_path)
  end

  def mark_not_accepted
    resume       = Resume.find(params[:resume_id])
    resume.update_attributes!(:status => "N_ACCEPTED")

    # Adding Comments 
    resume.add_resume_comment("NOT ACCEPTED: Candidate did not accept our offer.", "INTERNAL", get_current_employee)
    flash[:notice] = "You have succesfully marked #{resume.name} as not accepted"
    render body: nil
  end

  ###################################################################################################
  # FUNCTION    : Update joining date                                                                #
  # DESCRIPTION : Function to be used by ADMIN/HR to update joining date for resume                  #
  ####################################################################################################
  def update_joining
    joining_date      = params[:resume][:joining_date]
    status            = params[:resume][:status]
    comment           = params[:resume][:comment]
    resume            = Resume.find(params[:resume_id])

    # Avoiding resume status as SELECT
    status     = resume.status          if status == "SELECT"

    if (joining_date.nil? || joining_date == "")
      joining_date = resume.joining_date
    end

    # Updating resume attributes
    resume.update_attributes!(:joining_date => joining_date, :status => status)
    if comment =~ /Enter your comment/
      comment  = "No Comments added"
    end

    # Adding Comments
    resume.add_resume_comment("#{status}: " + comment, "INTERNAL", get_current_employee)

    email_for_joined(resume, status)

    render body: nil
  end

  ####################################################################################################
  # FUNCTION    : Will download resume                                                               #
  # DESCRIPTION : Function to be used by everyone to download particular resume                      #
  ####################################################################################################
  def download_resume
    @resume = params[:name]
    if File.extname(@resume) == "html"
      send_file(@resume, :disposition => "inline")
    else
      send_file(@resume)
    end
  end

  ####################################################################################################
  # FUNCTION    : forwarding_to_another_employee                                                     #
  # DESCRIPTION : Function to be used when somebody forward resume to someone                        #
  ####################################################################################################
  def forwarding_to_another_employee
    # Confusion that can we use the same resume here instead of params[:resume_id]
    counter_value = params[:counter_value]
    resume_id     = params[:resume_id]
    req_match     = params[:req_match]
    req_id        = params[:requirement_name]
    forward_id    = params["forward_id#{counter_value}".to_sym]

    unless params[:resume].nil?
      comment = params[:resume]["comment#{req_match}#{counter_value}#{resume_id}".to_sym]
    end
      
    if (!req_id || !forward_id)
      mesg = "Error in forwarding this resume to concerned employee.
              May be you did not select the requirement name from the list."
    elsif (req_id == "Select")
      mesg = "Please select a requirement name from the list."
    else
      # Check if a forward already exists with this resume/req
      resume = Forward.find(forward_id).resume
      mesg   = Resume.create_reqs(resume, [req_id], comment, get_logged_employee, get_current_employee) 
    end
    # Flashing messages
    logger.info(mesg)
    flash[:notice] = mesg
    redirect_back(fallback_location: root_path)
  end

  ####################################################################################################
  # FUNCTION    : resume_action                                                                      #
  # DESCRIPTION : Function to be used for all javascript actions                                     #
  ####################################################################################################
  def resume_action
    forward_id        = params[:forward_id]
    req_match_id      = params[:req_match_id]
    req_ids           = params[:req_ids]
    resume_id         = params[:resume_id]
    resume_comment    = params[:resume][:comment]

    # Find proper status(full name)
    status            = find_status(params[:status])

    # Checking errors in action
    check_resume_action_errors(req_match_id, req_ids, status)

    match = nil
    if req_match_id && req_match_id.to_i != 0
      match  = ReqMatch.find(req_match_id)
      resume = match.resume
    elsif forward_id && forward_id.to_i != 0
      forward = Forward.find(forward_id)
      resume = forward.resume
    else
      resume = Resume.find(resume_id) unless (resume_id.nil? || resume_id == 0)
    end

    req_matches = []
    unless status == "COMMENTED"
      if req_match_id && req_match_id.to_i != 0
        req_matches << ReqMatch.find(req_match_id)
      elsif req_ids
        req_ids.split(",").each do |req_id|
          req = Requirement.find(req_id)
          r   = ReqMatch.create(:forwarded_to   => req.employee,
                                :resume         => resume,
                                :status         => "SHORTLISTED",
                                :requirement_id => req_id)
          req_matches << r
        end
      end

      req_matches.each do |req_match|
        req_match.update_attributes!(:status => status)
      end
    end

    if status == "JOINING"
      joining_date = params[:joining_date]
      resume.update_attributes!(:joining_date => joining_date)
      email_for_joined(resume, "JOINING")
    end

    # In case the whole resume is rejected the req_match will be empty.
    if status == "REJECTED" && req_matches.size == 0
      resume.update_attributes!(:status => status) 
    end

    # ADDING: Comment
    if resume_comment.nil?   || resume_comment.empty? || resume_comment == "Add Comment" ||
       resume_comment =~ /Enter your comment/
      comment = "Resume " + status.titleize + " with no comments"
      ctype   = "INTERNAL"
    else
      comment = resume_comment
      ctype   = "USER"
    end

    req_names_a = []
    req_matches.each do |req_match|
      req_names_a << req_match.requirement.name
    end
    req_name = req_names_a.join(",")
    comment = comment + " for " + req_name unless req_name.empty?

    # Adding Comments
    resume.add_resume_comment("#{status}: " + comment, ctype, get_current_employee)

    # SENDING: Mail
    unless req_matches.nil? || req_matches.empty?
      req = req_matches[0].requirement
    else
      req = nil
    end
    email_for_action(resume, status, comment, req)

    if status == "ENG_SELECT" || status == "HAC" || status == "HOLD" || status == "YTO"
      if match
        email_for_decision(resume, match.requirement, false, status)
      end
    end

    if ( forward && status != "COMMENTED" ) ||
       ( req_ids )
      forward.status = "ACTION TAKEN"
      forward.save
    end

    render body: nil
  end

  ####################################################################################################
  # FUNCTION    : Decling interviews                                                                 #
  # DESCRIPTION : Function to be used when employee do not want to take interview on specified       #
  #               date/time                                                                          #
  ####################################################################################################
  def decline_interview
    # ACTION: Declined
    interview        = Interview.find(params[:interview_id])
    interview.status = "DECLINED"
    interview.save!

    # Sending mail
    send_email_for_declining(interview)

    render body: nil
  end

  ####################################################################################################
  # FUNCTION    : Mark Joining                                                                       #
  # DESCRIPTION : Function to be used when an resume will get joining date.                          #
  ####################################################################################################
  def mark_joining
    status       = "JOINING"
    match        = ReqMatch.find(params[:match])
    resume       = Resume.find(params[:resume_id])
    joining_date = params[:joining_date]

    overall_status = resume.resume_overall_status
    if overall_status == "Joining Date Given" ||
       overall_status == "JOINED"
      mesg = "This resume already marked as joining. So you can not mark joining two times on same resume."
      comment = "ALREADY JOINED: already marked as joining/joined"
    else
      resume.update_attributes!(:joining_date => joining_date)
      match.update_attributes!(:status => status)
      mesg = "You have succesfully added/updated the joining date(#{joining_date}) for #{resume.name}"
      comment = "JOINING: Marked Joining with no comments"
      email_for_joined(resume, "JOINING")
    end

    # Adding Comments 
    resume.add_resume_comment(comment, "INTERNAL", get_current_employee)
    flash[:notice] = mesg
    render body: nil
  end

  ####################################################################################################
  # FUNCTION    : create_multiple_forwards                                                           #
  # DESCRIPTION : Used if somebody forwards resume to more than one requirements                     #
  ####################################################################################################
  def create_multiple_forwards
    resume         = Resume.find(params[:resume_id])
    req_ids        = []

    if (params[:req_names] && params[:req_names].size > 0) 
      req_ids_array  = params[:req_names].split(",")
      req_ids_array.each do |r|
        req_ids << r
      end
      mesg = Resume.create_reqs(resume, req_ids, get_logged_employee, get_current_employee)
      flash[:notice] = mesg
    end
    render body: nil
  end

  ####################################################################################################
  # FUNCTION    : show_resume_comments                                                               #
  # DESCRIPTION : Function to be used when employee wants to see the comments on resume. Also we     #
  #               filtered comments on basis of current employee. If c_emp is HR/ADMIN then show all #
  #               resume comments else show only employee's comments                                 #
  ####################################################################################################
  def show_resume_comments
    @resume           = Resume.find(params[:resume_id])
    @cols             = params[:columns]
    if is_ADMIN? || is_HR? || is_MANAGER?
      @resume_comments      = @resume.comments
    else
      @resume_comments      = @resume.comments.find_all { |c|
        c.employee          == get_current_employee &&
        c.ctype             == "USER"
      }
    end
    @resume_comments        = sort_by_created_at_date(@resume_comments)

    respond_to do |format|
      format.js
    end
  end

  ####################################################################################################
  # FUNCTION    : show_resume_feedback                                                               #
  # DESCRIPTION : Function to be used when employee wants to see the feedback on resume. Also we     #
  #               filtered comments on basis of current employee. If c_emp is HR/ADMIN then show all #
  #               resume feedback else show only employee's feedback.                                #
  ####################################################################################################
  def show_resume_feedback
    resume            = Resume.find(params[:resume_id])
    @cols             = params[:columns]
    if is_ADMIN? || is_HR? || is_MANAGER?
      @resume_feedback  = resume.feedbacks
    else
      @resume_feedback  = resume.feedbacks.find_all { |feedback|
        feedback.employee == get_current_employee
      }
    end
    @resume_feedback   = sort_by_created_at_date(@resume_feedback)

    respond_to do |format|
      format.js
    end
  end

  ####################################################################################################
  # FUNCTION    : Show the interview request of the current employee                                 #
  # DESCRIPTION : Function to be used when employee wants to see his interview list to be taken.     #
  #               Also, Interviews are sorted based upon the time.                                   #
  ####################################################################################################
  def interview_requests
    # SQL sort on dates does not seem to work well. Sort first by date
    # then by time. Note that seconds_since_midnight is necessary as time
    # comparison does not work well otherwise.
    all_interviews    = get_current_employee.interviews.sort_by { |i| [i.interview_date ? i.interview_date : Date.today, i.interview_time.seconds_since_midnight] }
  
    @interview_requests      = []
    all_interviews.each do |interview|
      if interview.req_match.status == "SCHEDULED"
        @interview_requests << interview
      end
    end
    @interview_requests = @interview_requests.uniq
  end

  ####################################################################################################
  # FUNCTION    : Show the interview calendar of the all employees                                   #
  # DESCRIPTION : Function to be used when employee wants to see his interview list to be taken in   #
  #               a calendar.                                                                        #
  #               Also, Interviews are sorted based upon the time.                                   #
  ####################################################################################################
  def interview_calendar
  end

  def get_interviews
    require 'time'

    start_time = Time.at(params['start'].to_i).to_formatted_s(:db)
    end_time   = Time.at(params['end'].to_i).to_formatted_s(:db)
    if is_HR? || is_ADMIN?
      @events    = Interview.where("interview_date >= ? and interview_date <= ?",start_time ,end_time)
    else
      @events    = Interview.where("interview_date >= ? and interview_date <= ? and employee_id = ?", start_time, end_time,get_current_employee.id)
    end
    events     = []
    @events.each do |event|
      idate    = event.interview_date
      iso8601_format_time = event.interview_time.iso8601.dup
      iso8601_format_time.sub!("2000-01-01", idate.to_s)
      resume   = event.req_match.resume

      description = ""
      title       = ""
      if get_current_employee.is_HR? || get_current_employee.is_ADMIN?
        emp_email = event.employee.email
        emp_email.sub!("@mirafra.com", '')
        title     += "[" + emp_email + "] "
      end

      title       += resume.name
      description += event.req_match.requirement.name + "<br />" + resume.phone.to_s + "<br />" + (event.itype ? event.itype.titleize : "")

      events << { :id => event.id, :title => "#{title}", :description => "#{description}", :start => "#{iso8601_format_time}", :end => "", :allDay => 0, :recurring => false, :resume_uniqid => resume.uniqid.name, :interviewer_id => event.employee.id }
    end
    render plain: events.to_json
  end

  def interviews_status
    @interviews_late, @interviews_done, @under_process = ResumesController.filter_interviews_based_upon_processing
    if params[:mine]
      @interviews_late = @interviews_late.find_all{|r| r.resume.referral_type == "EMPLOYEE" && r.resume.referral_id == get_current_employee.id }
      @interviews_done = @interviews_done.find_all{|r| r.resume.referral_type == "EMPLOYEE" && r.resume.referral_id == get_current_employee.id }
      @under_process = @under_process.find_all{|r| r.resume.referral_type == "EMPLOYEE" && r.resume.referral_id == get_current_employee.id }
    end
  end

  ####################################################################################################
  # FUNCTION    : manager_interviews_status.                                                         #
  # DESCRIPTION : Show the list of manager's reqmatches whose status == "SCHEDULED"                  #
  #               Function to be used for REQ_MANAGER                                                #
  ####################################################################################################
  def manager_interviews_status
    @interviews_late, @interviews_done, @under_process = ResumesController.filter_interviews_based_upon_processing(get_current_employee)
    render "interviews_status" 
  end

  ####################################################################################################
  # FUNCTION    : export_interviews_per_date.                                                        #
  # DESCRIPTION : Generated out an excel file which has information about interview schedules for    #
  #               last 25 days and next 5 days.                                                          #
  ####################################################################################################
  def export_interviews_per_date
    start_date = Date.today - 25
    output                      = "#{Rails.root}/tmp/interviews_#{start_date.day}_#{start_date.month}.xls"
    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet::Workbook.new

    # Dump interview data for next 5 days into the excel
    end_date   = Date.today + 5
    start_date.upto(end_date) do |date|
      # Find interview corresponding to that date and continue with next date
      # if interviews are not available for that particular day. 
      interviews = Interview.where(interview_date:date)
      next if interviews.nil? || interviews.size == 0

      # Sorted interviews by respective requirement
      interviews.uniq { |r| r.req_match.requirement_id }
      interviews = interviews.sort { |x, y| x.req_match.requirement_id <=> y.req_match.requirement_id }

      # Creates the sheet with the date_month
      sheet = book.create_worksheet :name => "Interview_#{date.day}_#{date.month}"
      (0..9).each do |r|
        sheet.column(r).width = 20 
      end
      # Formatting the excel file
      blue = Spreadsheet::Format.new :size   => 10, :weight => :bold
      sheet.row(0).default_format = blue
      sheet.row(0).outline_level  = 1
      # Alok: TBD 
      sheet.row(0).push('Candidate name', 'Requirement name', 'Contact number', 'Email-id', 'Resume owner', 'Interview date', 'Interview time', 'Interview mode', 'Panel name')

      # Filling interview data into the row
      row = 1
      interviews.each do |r|
        row += 1;
        resume = r.req_match.resume
        resume_owner = ""
        resume_owner_type = ""
        unless resume.referral_type == "DIRECT"
          if resume.referral_id != 0
            resume_owner = get_referral_name(resume.referral_type, resume.referral_id).name
            resume_owner += "(" + resume.referral_type.titleize + ")"
          end
        end

        sheet.row(row).push( resume.name, r.req_match.requirement.name, resume.phone, resume.email, resume_owner, r.interview_date, r.interview_time.strftime('%T'), r.itype, r.employee.name)
      end
    end
    book.write output
    send_file(output)
  end

  def export_interviews
    start_date = Date.today
    end_date = Date.today
    Spreadsheet.client_encoding = 'UTF-8'
    output                      = "#{Rails.root}/tmp/interviews_#{Date.today.day}_#{Date.today.month}.xls"
    book                        = Spreadsheet::Workbook.new
    results = Interview.where("interview_date >= ? AND interview_date <= ?",start_date,end_date)
    results.uniq{ |r| r.req_match.requirement_id }
    results = results.sort { |x, y| x.req_match.requirement_id <=> y.req_match.requirement_id }

    sheet = book.create_worksheet :name => "Interviews"
    sheet.column(0).width = 30
    sheet.column(1).width = 30
    blue = Spreadsheet::Format.new :weight => :bold,
                                   :size   => 12
    sheet.row(0).default_format = blue
    row = 0
    sheet.row(row).push("Name")
    sheet.row(row).push("Requirement") 
    results.each do |r|
      row += 1;
      sheet.row(row).push(r.req_match.resume.name)
      sheet.row(row).push(r.req_match.requirement.name)
    end
    book.write output
    send_file(output)
  end

  ####################################################################################################
  # FUNCTION    : export_as_xls                                                                      #
  # DESCRIPTION : Function for dumping all requirement app status into an excel file.                #
  #               All resumes of whatever status they are will come into this excel file.            #
  ####################################################################################################
  def export_as_xls
    Spreadsheet.client_encoding = 'UTF-8'
    output                      = "#{Rails.root}/tmp/status_#{Date.today.day}_#{Date.today.month}.xls"
    book                        = Spreadsheet::Workbook.new
    forwarded_sheet             = book.create_worksheet :name => "Forwarded"
    shortlisted_sheet           = book.create_worksheet :name => "Shortlisted"
    offered_sheet               = book.create_worksheet :name => "Offered"
    joining_sheet               = book.create_worksheet :name => "Joining"
    interviews_sheet            = book.create_worksheet :name => "Interviews"

    forwarded                   = get_hr_matches("FORWARDED")
    fill_forwarded_shortlisted_data(forwarded_sheet, forwarded)
    shortlisted                 = get_hr_matches("SHORTLISTED")
    fill_forwarded_shortlisted_data(shortlisted_sheet, shortlisted)
    offered_matches             = get_all_req_matches_of_status("OFFERED")
    fill_offered_data(offered_sheet, offered_matches)

    find_filter_interviews_based_upon_processing
    all_interview_matches       = @interviews_late + @interviews_done + @under_process
    fill_interview_data(interviews_sheet, all_interview_matches)

    joining_matches, joined_resumes, not_joined_resumes = find_joining_resumes
    fill_joining_data(joining_sheet, joining_matches, joined_resumes, not_joined_resumes)

    book.write output

    # Send the file to download
    send_file(output)
  end

  ####################################################################################################
  # FUNCTION    : create_xls_sheet_and_get_matches                                                   #
  # DESCRIPTION : Create the excel sheet and find the req matches related to the requirement         #
  ####################################################################################################
  def create_xls_sheet_and_get_matches(for_status)
    requirement                 = Requirement.find(params[:requirement_id])
    Spreadsheet.client_encoding = 'UTF-8'
    book                        = Spreadsheet::Workbook.new
    sheet                       = book.create_worksheet :name => for_status
    output                      = "#{Rails.root}/tmp/requirement_"  + for_status.downcase + "_status_#{requirement.name.gsub(/[& -\/\\]/, '_')}.xls"
    unless for_status == "JOINING"
      req_forwards              = requirement.forwards
      req_forwards              += requirement.req_matches
      forwards                  = req_forwards.find_all { |f| f.status     == for_status }
    else
      req_forwards              = requirement.req_matches
      forwards                  = req_forwards
    end
    [ sheet, book, output, forwards ]
  end

  def send_file_to_download(book, output)
    book.write output
    send_file(output)
  end

  ####################################################################################################
  # FUNCTION    : export_as_xls_requirement_for_shortlisted etc....                                  #
  # DESCRIPTION : Function for dumping requirement specific status into an excel file.               #
  #               E.g. If you want only shorlisted status of requirement A.                          #
  ####################################################################################################
  def export_as_xls_requirement_for_shortlisted
    sheet, book, output, shortlist_matches = create_xls_sheet_and_get_matches("SHORTLISTED")
    fill_forwarded_shortlisted_data(sheet, shortlist_matches)
    send_file_to_download(book, output)
  end

  def export_as_xls_requirement_for_forwards
    sheet, book, output, forward_matches   = create_xls_sheet_and_get_matches("FORWARDED")
    fill_forwarded_shortlisted_data(sheet, forward_matches)
    send_file_to_download(book, output)
  end

  def export_as_xls_requirement_for_offered
    sheet, book, output, offered_matches   = create_xls_sheet_and_get_matches("OFFERED")
    fill_offered_data(sheet, offered_matches)
    send_file_to_download(book, output)
  end

  def export_as_xls_requirement_for_scheduled
    sheet, book, output, scheduled_matches   = create_xls_sheet_and_get_matches("SCHEDULED")
    fill_interview_data(sheet, scheduled_matches)
    send_file_to_download(book, output)
  end

  def export_as_xls_requirement_for_rejected
    sheet, book, output, rejected_matches   = create_xls_sheet_and_get_matches("REJECTED")
    fill_forwarded_shortlisted_data(sheet, rejected_matches)
    send_file_to_download(book, output)
  end

  def export_as_xls_requirement_for_hold
    sheet, book, output, hold_matches   = create_xls_sheet_and_get_matches("HOLD")
    fill_forwarded_shortlisted_data(sheet, hold_matches)
    send_file_to_download(book, output)
  end

  def export_as_xls_requirement_for_joining
    sheet, book, output, join_matches   = create_xls_sheet_and_get_matches("JOINING")
    joining_matches             = join_matches.find_all { |f| f.status           == "JOINING" && f.resume.status    != "JOINED" &&
                                                              f.resume.status    != "NOT JOINED" }

    joined_matches              = join_matches.find_all { |f| f.resume.status == "JOINED" }
    joined_matches              = uniqify_forwards(joined_matches)
    joined_resumes              = []
    joined_matches.each do |m|
      joined_resumes   << m.resume
    end

    not_joined_matches          = join_matches.find_all { |f| f.resume.status == "NOT JOINED" }
    not_joined_matches          = uniqify_forwards(not_joined_matches)
    not_joined_resumes          = []
    not_joined_matches.each do |m|
      not_joined_resumes  << m.resume
    end

    fill_joining_data(sheet, joining_matches, joined_resumes, not_joined_resumes)
    send_file_to_download(book, output)
  end

  ####################################################################################################
  # FUNCTION    : export_as_xls_requirement                                                          #
  # DESCRIPTION : Function for dumping all requirement status into an excel file.                    #
  #               Also giving the hyper links on resume names.                                       #
  ####################################################################################################
  def export_as_xls_all_uploaded_resumes
   Spreadsheet.client_encoding = 'UTF-8'
   book                        = Spreadsheet::Workbook.new
   if get_current_employee.is_HR?
     resumes                     = get_current_employee.resumes 
     output                      = "#{Rails.root}/tmp/All_Uploaded_Resumes.xls"
     sheet                       = book.create_worksheet :name => "Resumes"
     fill_resume_data(sheet, resumes)
     send_file_to_download(book, output)
   else
     flash[:notice] = "You are not authorised to access this page"
     redirect_back(fallback_location: root_path)
   end
  end

  def export_as_xls_requirement
    Spreadsheet.client_encoding = 'UTF-8'
    book                        = Spreadsheet::Workbook.new
    requirement                 = Requirement.find(params[:requirement_id])
    req_forwards                = requirement.forwards
    req_forwards                += requirement.req_matches
    output                      = "#{Rails.root}/tmp/requirement_full_status_#{requirement.name.gsub(/[& -\/\\]/, '_')}.xls"
    forwarded_sheet             = book.create_worksheet :name => "Forwarded"
    shortlisted_sheet           = book.create_worksheet :name => "Shortlisted"
    rejected_sheet              = book.create_worksheet :name => "Rejected"
    offered_sheet               = book.create_worksheet :name => "Offered"
    joining_sheet               = book.create_worksheet :name => "Joining"
    interviews_sheet            = book.create_worksheet :name => "Interviews"

    forwarded                   = req_forwards.find_all { |f| f.status     == "FORWARDED" }
    fill_forwarded_shortlisted_data(forwarded_sheet, forwarded)
    shortlisted                 = req_forwards.find_all { |f| f.status     == "SHORTLISTED" }
    fill_forwarded_shortlisted_data(shortlisted_sheet, shortlisted)
    rejected                    = req_forwards.find_all { |f| f.status     == "REJECTED" }
    fill_forwarded_shortlisted_data(rejected_sheet, rejected)
    offered_matches             = req_forwards.find_all { |f| f.status     == "OFFERED" }
    fill_offered_data(offered_sheet, offered_matches)

    interview_matches           = req_forwards.find_all { |f|
      f.status                  == "SCHEDULED"
    }
    fill_interview_data(interviews_sheet, interview_matches)

    joining_matches             = requirement.req_matches.find_all { |f| f.status           == "JOINING" && f.resume.status    != "JOINED" &&
                                                                         f.resume.status    != "NOT JOINED" }
    joined_matches              = requirement.req_matches.find_all { |f| f.resume.status == "JOINED" }
    joined_matches              = uniqify_forwards(joined_matches)
    joined_resumes              = []
    joined_matches.each do |m|
      joined_resumes   << m.resume
    end

    not_joined_matches          = requirement.req_matches.find_all { |f| f.resume.status == "NOT JOINED" }
    not_joined_matches          = uniqify_forwards(not_joined_matches)
    not_joined_resumes          = []
    not_joined_matches.each do |m|
      not_joined_resumes  << m.resume
    end

    fill_joining_data(joining_sheet, joining_matches, joined_resumes, not_joined_resumes)
    book.write output

    # Send the file to download
    send_file(output)
  end

  ####################################################################################################
  # FUNCTION    : show_quarterly_joined                                                              #
  # DESCRIPTION : Used to show joined resumes of that time period/quarter                            #
  ####################################################################################################
  def show_quarterly_joined
    @smonth = params[:smonth].to_i
    @emonth = params[:emonth].to_i
    @year   = params[:year].to_i
    @status = params[:status]

    @joined_resumes              = Resume.find_all_by_status(@status).find_all { |resume| 
                                                          resume.joining_date && 
                                                          resume.joining_date.month >= @smonth &&
                                                          resume.joining_date.month <= @emonth &&
                                                          resume.joining_date.year  == @year }
    render "resumes/_show_quarterly_joined", :layout => false
  end

  ####################################################################################################
  # FUNCTION    : show_all_joined_or_not_joined                                                      #
  # DESCRIPTION : Function added to get all joined/not joined resumes and send them using render.    #
  ####################################################################################################
  def show_all_joined_or_not_joined
    @status           = params[:status]
    @joined_resumes   = Resume.find_all_by_status(@status)
    @joined_resumes   = @joined_resumes.sort_by { |r| [!r.joining_date.nil? ?  r.joining_date : Date.today ] }
    render "resumes/_show_quarterly_joined", :layout => false
  end

  ####################################################################################################
  # FUNCTION    : show_quarterly_offered                                                             #
  # DESCRIPTION : Used to show offered resumes of that time period/quarter                           #
  ####################################################################################################
  def show_quarterly_offered
    @smonth = params[:smonth].to_i
    @emonth = params[:emonth].to_i
    @year   = params[:year].to_i
    @status = params[:status]

    offered_comments = Comment.all.find_all { |c| c.comment.include?("OFFERED") &&
                                                  c.created_at.month >= @smonth &&
                                                  c.created_at.month <= @emonth &&
                                                  c.created_at.year  == @year }
    @offered_comments = offered_comments.sort_by { |c| [c.created_at] }
    @offered_comments.uniq { |c| c.resume }

    render "resumes/_show_quarterly_offered", :layout => false
  end

  def show_quarterly_not_accepted
    @smonth = params[:smonth].to_i
    @emonth = params[:emonth].to_i
    @year   = params[:year].to_i
    date = Date.new(@year, @smonth, 1)
    @not_accepted_comments = get_quarterly_comments_not_accepted(date)
    render "resumes/_show_quarterly_not_accepted", :layout => false
  end

  ####################################################################################################
  # FUNCTION    : show_all_joined_or_not_joined                                                      #
  # DESCRIPTION : Function added to get all joined/not joined resumes and send them using render.    #
  ####################################################################################################
  def show_all_offered
    @status           = params[:status]
    offered_comments  = Comment.all.find_all {|c| c.comment.include?(@status) }
    @offered_comments = offered_comments.sort_by { |c| [c.created_at] }
    @offered_comments.uniq { |c| c.resume }

    render "resumes/_show_quarterly_offered", :layout => false
  end

  def show_all_not_accepted
    @status = "NOT ACCEPTED"
    @not_accepted_comments = get_quarterly_comments_not_accepted(nil)
    render "resumes/_show_quarterly_not_accepted", :layout => false
  end

  ####################################################################################################
  # FUNCTION    : feedback                                                                           #
  # DESCRIPTION : Used to add feedback for resume                                                    #
  ####################################################################################################
  def feedback
    @current_employee = get_current_employee
    resume   = Resume.find(params[:feedback][:resume_id])
    req      = Requirement.find_by_name(params[:requirement_name])

    unless params[:feedback][:rating] == "Select"
      feedback = Feedback.new(params[:feedback].permit!)
      if params[:resume][:comment] =~ /Enter your comment/ ||
         params[:resume][:comment] == ""
        feedback.feedback = "Only rating added"
      else
        feedback.feedback = params[:resume][:comment]
      end
      # Adding feedback
      Feedback.transaction do
        feedback.employee = @current_employee
        feedback.resume   = resume
        feedback.save!
        flash[:notice] = "We thank you for submitting the feedback about this resume"
      end
      # Sending email about feedback
      email_for_feedback(resume, feedback, req)
    else
      flash[:notice] = "Please select rating also"
    end

    redirect_back(fallback_location: root_path)
  end

  ####################################################################################################
  # FUNCTIONS   : inbox, outbox, trash, add_message, delete_messages, reply_to                       #
  # DESCRIPTION : Methods written for messaging.                                                     #
  ####################################################################################################
  def inbox
    @inbox = get_current_employee.in_messages.where(is_deleted: false)
      
    @inbox = sort_by_created_at_date(@inbox)
    @inbox = @inbox.paginate(:page => params[:page], :per_page => get_per_page)
  end

  def outbox
    @outbox = get_current_employee.out_messages
    @outbox = sort_by_created_at_date(@outbox)
    @outbox = @outbox.paginate(:page => params[:page], :per_page => get_per_page)
  end

  def trash
    @trash = get_current_employee.in_messages.find_all { |m|
      m.deleted == true
    }
    @trash = sort_by_created_at_date(@trash)
    @trash = @trash.paginate(:page => params[:page], :per_page => get_per_page)
  end

  def add_message
    resume_id         = params[:resume_id]
    message           = params[:resume][:comment]
    counter_value     = params[:counter_value]
    employee          = params[:employee_id]
    req_match         = params[:req_match]

    # Creating message
    message           = "No Message" if message.nil? || message.empty? ||
                                        message == "Enter your comment and click on arrow to message"
    m = Message.new(:resume_id => resume_id, :sent_to => Employee.find_by_name(employee),
                    :message   => message,   :sent_by => get_current_employee)
    m.save!

    # Creating message's reply_to field
    m.update_attributes(:reply_to => m.id)

    # Send mail when adding message
    email_for_add_message(m)

    # After rendering this we do not need to create an js file for add_message
    # (add_message.js)
    render "resume_action.js"
  end

  def delete_selected_message
    for i in 1..10
      chkbox_value = params["chkbox_number#{i}".to_sym]
      if chkbox_value
        message = Message.find(chkbox_value)
        message.update_attributes!(:is_deleted => 1)
      end
    end

    flash[:notice] = "You have successfully deleted the selected messages"
    redirect_back(fallback_location: root_path)
  end

  def reply_message
    # TODO: Send email while replying to an message
    comment = params[:resume][:comment]
    mesg    = Message.find(params[:message_id])
    resume  = mesg.resume
    # Update is_replies field in old message
    mesg.update_attributes(:is_replied => true)

    # Creating new message to send
    m       = Message.new(:message   => comment,    :sent_to => Employee.find(mesg.sent_by),
                          :resume_id => resume.id,  :sent_by => get_current_employee,
                          :reply_to  => mesg.id)
    m.save!

    # Send mail when replying
    email_for_add_message(m)

    flash[:notice] = "Your message has been sent."
    redirect_back(fallback_location: root_path)
  end

  # Function to set is_read
  def set_is_read
    message = Message.find(params[:message_id])
    message.update_attributes!(:is_read => true)

    # After rendering this we do not need to create an js file
    # (set_is_read.js)
    render "resume_action.js"
  end

  ####################################################################################################
  # FUNCTIONS   : Add Interviews                                                                     #
  # DESCRIPTION : Function to be used to add more interviews to a req match                          #
  ####################################################################################################
  def add_interviews
    emp_added_for_interviews = []
    row_index = params[:row_index].to_i 
    int_stage = params[:interview_stage]
    int_type  = params[:interview_type]
    match     = ReqMatch.find(params[:req_match_id])

    for i in row_index..row_index
      emp_id    = params["interview_employee_name#{i}".to_sym]
      int_time  = params["time_slot#{i}".to_sym]
      int_date  = params["interview_date#{i}"]
      int_focus = params["interview_focus#{i}".to_sym]
      i_time = Time.zone.parse (int_date + " " + int_time)
      if emp_id
        interview = Interview.new(:employee_id    => emp_id,
                                  :interview_date => int_date,
                                  :interview_time => i_time,
                                  :stage          => int_stage,
                                  :itype          => int_type,
                                  :focus          => int_focus,
                                  :req_match_id   => match.id)
        is_save = interview.save
        if is_save
          # Making an .ics file. Not sure this is an good idea to create ics file here.
          # Will change it asap.
          ics_file = File.new(Rails.root + "/tmp/" + "#{match.resume.uniqid.name}", "w")
            ics_file.puts "BEGIN:VCALENDAR"
            ics_file.puts "VERSION:1.0"
            ics_file.puts "BEGIN:VEVENT"
            ics_file.puts "CATEGORIES:MEETING"
            ics_file.puts "STATUS:#{interview.status}"

            # Finding start and end times
            # Decreasing 5 and half hours to make it compatible with indian time
            # 60*60*5 + 1800 (Not sure this is good idea)
            original_interview_time   = interview.interview_time
            iso8601_start_format_time = original_interview_time - 19800
            iso8601_start_format_time = iso8601_start_format_time.iso8601.dup
            iso8601_end_format_time   = original_interview_time - 19800 + 3600   # Added 3600 seconds to extend time to two hours :). Will find a better idea over this weekend probably
            iso8601_end_format_time   = iso8601_end_format_time.iso8601.dup
            # Start Time
            iso8601_start_format_time.gsub!("2000-01-01", interview.interview_date.to_s)
            iso8601_start_format_time.gsub!(/[:-]/, "")
            # End Time
            iso8601_end_format_time.gsub!("2000-01-01", interview.interview_date.to_s)
            iso8601_end_format_time.gsub!(/[:-]/, "")

            ics_file.puts "DTSTART:#{iso8601_start_format_time}"
            ics_file.puts "DTEND:#{iso8601_end_format_time}"
            ics_file.puts "SUMMARY: STAGE- #{interview.stage}, INTERVIEW TYPE- #{interview.itype}"
            ics_file.puts "DESCRIPTION: FOCUS- #{interview.focus}"
            ics_file.puts "CLASS:PRIVATE"
            ics_file.puts "BEGIN:VALARM"
            ics_file.puts "TRIGGER:-PT15M"
            ics_file.puts "ACTION:DISPLAY"
            ics_file.puts "DESCRIPTION: Reminder"
            ics_file.puts "END:VALARM"
            ics_file.puts "END:VEVENT"
            ics_file.puts "END:VCALENDAR"
          ics_file.close

          # Scheduled only when interview get saved
          match.update_attributes!(:status => "SCHEDULED")

          # Adding employees to an array for comments
          employee  = interview.employee
          emp_added_for_interviews << employee.name
  
          # Sending emails to added panels
          email_for_adding_panel(employee, interview, match.resume)

          # Removing file from tmp
          File.delete(Rails.root + "/tmp/" + "#{match.resume.uniqid.name}")
        end
      end
    end

    if is_save
      # Sending email to req manager for notification
      notify_manager_for_panel(match.requirement, match.resume, emp_added_for_interviews.join(", "))

      # Adding comment
      match.resume.add_resume_comment("ADDING INTERVIEWS FOR: #{emp_added_for_interviews.join(", ")} for requirement #{match.requirement.name}", "INTERNAL", get_current_employee)

      flash[:notice] = "You have successfully added interview panel"
      redirect_back(fallback_location: root_path)
    elsif interview.errors
      error_catching_and_flashing(interview)

      # Adding comment
      match.resume.add_resume_comment("OVERLAPPING INTERVIEWS DATE/TIME: #{emp_added_for_interviews.join(", ")} for requirement #{match.requirement.name}", "INTERNAL", get_current_employee)
    end
  end

  ####################################################################################################
  # FUNCTIONS   : Update Interviews                                                                  #
  # DESCRIPTION : Function to be used to update interviews to a req match                            #
  ####################################################################################################
  def update_interview
    int_id    = params[:interview_id]
    emp_id    = params[:interview_employee_name]
    int_time  = params[:interview_time]
    int_date  = params[:interview_date]
    int_focus = params[:interview_focus]

    interview = Interview.find(int_id)
    is_save = interview.update_attributes(:employee_id    => emp_id,
                                :interview_date => int_date,
                                :interview_time => int_time,
                                :focus          => int_focus)

    match     = interview.req_match
    resume    = match.resume

    if is_save
      # Email for updating panels
      email_for_adding_panel(interview.employee, interview, resume)

      # Sending email to req manager for notification
      notify_manager_for_panel(match.requirement, resume, interview.employee.name)

      # Adding comment
      resume.add_resume_comment("UPDATING INTERVIEWS: Interview panel updated", "INTERNAL", get_current_employee)

      # Flashing message
      flash[:notice] = "You have successfully updated the interview details"
      redirect_back(fallback_location: root_path)
    elsif interview.errors
      error_catching_and_flashing(interview)
    end

  end

  ####################################################################################################
  # FUNCTIONS   : manage_interviews                                                                  #
  # DESCRIPTION : Will display the interviews of particular req match. Function to be used to        #
  #               delete/add interviews for a req match.                                             #
  ####################################################################################################
  def manage_interviews
    @req_match  = ReqMatch.find(params[:req_match_id])
    @interviews = @req_match.interviews

    respond_to do |format|
      format.js
    end
  end

  ####################################################################################################
  # FUNCTIONS   : Delete interview                                                                   #
  # DESCRIPTION : Function to be used when HR/ADMIN/REQ_MANAGER deletes the interview already existed#
  #               Also if there are no interviews left associated to the req_match then we need to   #
  #               change the status of that req_match to shortlisted                                 #
  ####################################################################################################
  def delete_interview
    # Find interview from the params coming
    interview    = Interview.find(params[:id])
    interview.destroy

    # Find Req Match from the same interview
    req_match    = interview.req_match

    # Find employee and resume name
    emp_name     = interview.employee.name
    resume_name  = req_match.resume.name

    # Flash message to display by default
    flash_mesg   = "You have successfully deleted the interview of #{emp_name} for #{resume_name}."

    # Comment to be added
    comment      = "Deleted #{emp_name} from interview panel for #{req_match.requirement.name}."

    # If interviews size is zero then change status as SCHEDULED
    total_left_interviews = req_match.interviews.size
    if total_left_interviews == 0
      req_match.update_attributes!(:status => "SHORTLISTED")
      flash_mesg += " Also there are no more interviews left for #{resume_name}. So we are marking this resume as \"SHORTLISTED\""
      comment    += " Also marking resume as shortlisted as all interviews deleted."
    end
    email_after_deleting_interview(interview, req_match.resume)

    req_match.resume.add_resume_comment("INTERVIEW DELETED: " + comment, "INTERNAL", get_current_employee)
    flash[:notice] = flash_mesg
    redirect_back(fallback_location: root_path)
  end

  ####################################################################################################
  # FUNCTIONS   : add_interview_status_to_resume                                                     #
  # DESCRIPTION : Will add interview status to resume. We have provided a field(status) in           #
  #               req matches for better differentiating. This function to be used when somebody     #
  #               (HR/ADMIN/REQ_MANAGER) wants to add status to req_match)                           #
  ####################################################################################################
  def add_interview_status_to_req_matches
    match    = ReqMatch.find(params[:req_match_id])
    status   = params[:resume][:comment]
    if (status =~ /Enter your comment/)
      status = ''
    end
    match.resume.update_attributes!(:manual_status => status)
    comment  = "No status added"
    if status
      comment = status
    end

    match.resume.add_resume_comment("SET REQMATCH STATUS: " + comment, "INTERNAL", get_current_employee)

    # After rendering this we do not need to create an js file for add_interview_status_to_req_matches
    # (add_interview_status_to_req_matches.js)
    render "resume_action.js"
  end

  def add_manual_status_to_resume
    resume        = Resume.find(params[:resume_id])
    manual_status = params[:resume][:comment]
    if (manual_status =~ /Enter your comment/)
      manual_status = ''
    end
    resume.update_attributes!(:manual_status => manual_status);

    comment  = "No status added"
    if manual_status
      comment = manual_status
    end
    resume.add_resume_comment("SET MANUAL STATUS: " + comment, "INTERNAL", get_current_employee)

    # After rendering this we do not need to create an js file for add_interview_status_to_req_matches
    # (add_interview_status_to_req_matches.js)
  end

  ####################################################################################################
  # FUNCTIONS   : find_interviews_status(Static method)                                              #
  # DESCRIPTION : Function to be used to find interviews of all type.                                #
  #               Interviews which are gone. Interviews which are late.                              #
  #               Interviews with feedback came.                                                     #
  ####################################################################################################
  def ResumesController.find_interviews_status(matches)
    late          = []
    done          = []
    processing    = []
    matches.each do |match|
      interviews   = match.interviews
      feedbacks    = match.resume.feedbacks

      employees_with_feedback = []
      feedbacks.each do |f|
        employees_with_feedback << f.employee
      end

      feedback_late = false
      in_future = false
      interviews.each do |i|
        if i.interview_date
          if (i.interview_date >= Date.today)
            in_future = true
          elsif !employees_with_feedback.include?(i.employee)
            feedback_late = true
          end
        end
      end

      if (feedback_late)
        late << match
      elsif (in_future)
        processing << match
      else
        done << match
      end
    end
    late.sort_by       { |r| [r.requirement.group_id, r.requirement.employee_id, r.requirement_id] }
    done.sort_by       { |r| [r.requirement.group_id, r.requirement.employee_id, r.requirement_id] }
    processing.sort_by { |r| [r.requirement.group_id, r.requirement.employee_id, r.requirement_id] }

    [ late, done, processing ]
  end

  def update_resume_likely_to_join
    likely_to_join = params[:likely_to_join]
    resume         = Resume.find(params[:resume_id])
    resume.update_attributes!(:likely_to_join => likely_to_join)
    # respond_to do |format|
    #   format.json { :json => resume.likely_to_join }
    # end
    render body: nil
  end

  private

  # PRIVATE FUNCTIONS
  # NOT TO BE USED ANYWHERE ELSE THAN THIS CONTROLLER

  ####################################################################################################
  # FUNCTIONS   : find_interviews_status(Static method)                                              #
  # DESCRIPTION : Function to be used to find interviews of all type.                                #
  #               Interviews which are done. Interviews which are late.                              #
  #               Interviews which are under process                                                 #
  ####################################################################################################
  def ResumesController.filter_interviews_based_upon_processing(employee = nil)
    unless employee.nil?
      req_matches = ReqMatch.find_employee_requirements_req_matches(employee, false)
      req_matches += ReqMatch.find_scheduling_employee_req_matches(employee, false)
    else
      req_matches = ReqMatch.all
    end

    all_matches   = req_matches.find_all { |match|
      ( match.status                       == "SCHEDULED" ) &&
      ( match.resume.resume_overall_status == "Interview Scheduled" )
    }

    @interviews_late, @interviews_done, @under_process = ResumesController.find_interviews_status(all_matches)
  end

  ####################################################################################################
  # FUNCTIONS   : check_resume_action_errors                                                         #
  # DESCRIPTION : Function used in resume_action method. Here we are checking different error        #
  #               conditions for req_ids and req_match_id                                            #
  ####################################################################################################
  def check_resume_action_errors(req_match_ids, req_ids, status)
    if ( ( req_match_ids && req_match_ids.size > 0 ) &&
         ( req_ids && req_ids.size > 0 )             &&
         ( status != "COMMENTED" ) )
      logger.error("Got non empty req_match_ids and req_ids in resume_action")
      redirect_back(fallback_location: root_path)
    end

    if ( ( req_match_ids.nil? || req_match_ids.size == 0 ) &&
         ( req_ids.nil? || req_ids.size == 0 )             &&
         ( status != "COMMENTED" ) )
      logger.error("Got both empty req_match_ids and req_ids in resume_action")
      redirect_back(fallback_location: root_path)
    end

    if status != "SHORTLISTED" && status != "REJECTED"
      if (req_match_ids && req_match_ids.size > 1 &&
          req_ids && req_ids.size > 1) 
        logger.error("more than one req's allowed only for SHORTLISTED and REJECTED, got for #{status}")
        redirect_back(fallback_location: root_path)
      end
    end
  end

  ####################################################################################################
  # FUNCTIONS   : find_resumes_with_status                                                           #
  # DESCRIPTION : Find resume with specified status                                                  #
  ####################################################################################################
  def find_resumes_with_status(status)
    Resume.all.find_all { |r|
      r.resume_overall_status == status
    }
  end

  ####################################################################################################
  # FUNCTIONS   : find_filter_interviews_based_upon_processing                                       #
  # DESCRIPTION : Function to be used for interviews_status                                          #
  ####################################################################################################
  def find_filter_interviews_based_upon_processing
    @interviews_late, @interviews_done, @under_process = ResumesController.filter_interviews_based_upon_processing
  end

  ####################################################################################################
  # FUNCTIONS   : get_matches                                                                        #
  # DESCRIPTION : Function to be used by REQ_MANAGERS when we need to show their requirement's status#
  #               Resumes corresponding to their requirements.                                       #
  ####################################################################################################
  def get_matches(status, open_reqs_only)
    @row_id_prefix  = get_row_id_prefix(status)
    forwards        = get_req_matches_of_status(status, open_reqs_only)

    uniq_forwards = uniqify_forwards(forwards)
    uniq_forwards
  end

  def get_hr_rejects
    @row_id_prefix = get_row_id_prefix("REJECTED")
    forwards       = Forward.find_all_by_status("REJECTED").find_all { |f|
      f.resume.rejected?
    }
    forwards      += ReqMatch.find_all_by_status("REJECTED").find_all { |r|
      r.resume.rejected? &&
      r.requirement.isOPEN?
    }

    uniq_forwards = uniqify_forwards(forwards)
    uniq_forwards
  end

  def get_hr_matches_cached(status)
    @row_id_prefix = get_row_id_prefix(status)
    resumes = Resume.where(status:status)
    forwards = []
    resumes.each do |r|
      r.req_matches.each do |m|
        if m.status == status
          forwards << m
          break
        end
      end
    end

    uniq_forwards = uniqify_forwards(forwards)
    uniq_forwards
  end

  ####################################################################################################
  # FUNCTIONS   : get_hr_matches                                                                     #
  # DESCRIPTION : Function to be used by HR/ADMIN when we need to show all requirement's status.     #
  #               Resumes corresponding to all requirements.                                         #
  ####################################################################################################
  def get_hr_matches(status)
    @row_id_prefix = get_row_id_prefix(status)
    forwards       = Forward.where(status:status) { |f|
      f.resume.resume_overall_status == status.capitalize
    }
    forwards      += ReqMatch.where(status:status) { |r|
      r.resume.resume_overall_status == status.capitalize &&
      r.requirement.isOPEN?
    }

    uniq_forwards = uniqify_forwards(forwards)
    uniq_forwards
  end

  ####################################################################################################
  # FUNCTIONS   : get_req_matches_of_status                                                          #
  # DESCRIPTION : Function to be used to find req matches of current employee. First we are finding  #
  #               all the requirements of current employee and then from those reqs we are finding   #
  #               all the req_matches of that employee.                                              #
  ####################################################################################################
  def get_req_matches_of_status(status, open_reqs_only)
    req_matches = ReqMatch.find_employee_requirements_req_matches(get_current_employee, open_reqs_only).find_all { |r|
      r.status == status 
    }

    if (status == 'SHORTLISTED') 
      req_matches += ReqMatch.find_scheduling_employee_req_matches(get_current_employee, open_reqs_only).find_all { |r|
        r.status == status
      }
    end

    req_matches.sort {|x, y| x.requirement_id <=> y.requirement_id}
    # req_matches += get_current_employee.forwards.find(:all) {
    #   |fwd| fwd.status == status
    # }
    # TODO: Above code is throwing this error
    # irb(main):006:0> get_current_employee.forwards
    # Traceback (most recent call last):
    # SystemStackError (stack level too deep)
    return req_matches
  end

  # TODO: Minimize this code as well
  ####################################################################################################
  # FUNCTIONS   : find_status                                                                        #
  # DESCRIPTION : Find status which need to be stored in database. From javascript we are sending   #
  #               status as small letters(except shortlist).                                         #
  ####################################################################################################
  def find_status(istatus)
    if istatus    == "Add Comment"
      return "COMMENTED"
    elsif istatus == "Shortlist"
      return "SHORTLISTED"
    elsif istatus == "Reject"
      return "REJECTED"
    elsif istatus == "Hold"
      return "HOLD"
    elsif istatus == "Offer"
      return "OFFERED"
    elsif istatus == "Offered"
      return "OFFERED"
    elsif istatus == "Joining"
      return "JOINING"
    else
      return istatus
    end
  end

  def fill_joining_data(sheet, joining_matches, joined_resumes, not_joined_resumes)
    sheet.row(0).push "Joining"
    sheet.row(1).concat %w{Name Req Date Email Phone\ Number Referral}

    sheet.column(0).width = 30
    sheet.column(1).width = 30
    sheet.column(2).width = 30
    sheet.column(3).width = 30
    sheet.column(4).width = 30
    sheet.column(5).width = 30

    blue = Spreadsheet::Format.new :weight => :bold,
                                   :size   => 12
    sheet.row(0).default_format = blue
    sheet.row(1).default_format = blue
    row = 2
    joining_matches.each do |m|
      sheet.row(row).height = 20
      sheet.row(row).push Spreadsheet::Link.new get_resume_url(m.resume.uniqid), m.resume.name
      sheet.row(row).push m.requirement.name
      sheet.row(row).push m.resume.joining_date
      sheet.row(row).push m.resume.email
      sheet.row(row).push m.resume.phone
      sheet.row(row).push m.resume.referral_name
      row += 1
    end

    row +=4
    sheet.row(row).push "Joined"
    sheet.row(row).default_format = blue
    row += 1

    joined_resumes.each do |r|
      sheet.row(row).height = 20
      sheet.row(row).push Spreadsheet::Link.new get_resume_url(r.uniqid), r.name
      sheet.row(row).push ""
      sheet.row(row).push r.joining_date
      sheet.row(row).push r.email
      sheet.row(row).push r.phone
      sheet.row(row).push r.referral_name
      row += 1
    end

    row += 4
    sheet.row(row).push "Not Joined"
    sheet.row(row).default_format = blue
    row += 1
    not_joined_resumes.each do |r|
      sheet.row(row).height = 20
      sheet.row(row).push Spreadsheet::Link.new get_resume_url(r.uniqid), r.name
      sheet.row(row).push ""
      sheet.row(row).push r.joining_date
      sheet.row(row).push r.email
      sheet.row(row).push r.phone
      sheet.row(row).push r.referral_name
      row += 1
    end
  end

  def fill_offered_data(sheet, matches)

    sheet.column(0).width = 30
    sheet.column(1).width = 50
    sheet.column(2).width = 30
    sheet.column(3).width = 30
    sheet.column(4).width = 30
    sheet.column(5).width = 30
    sheet.column(6).width = 30

    sheet.row(0).concat %w{Name Current\ Company Req Status Email Phone Referral}
    blue = Spreadsheet::Format.new :weight => :bold,
                                   :size   => 12
    sheet.row(0).default_format = blue
    row = 1
    matches.each do |m|
      sheet.row(row).height = 20
      sheet.row(row).push Spreadsheet::Link.new get_resume_url(m.resume.uniqid), m.resume.name
      sheet.row(row).push m.resume.current_company
      sheet.row(row).push m.requirement.name
      sheet.row(row).push m.resume.resume_overall_status
      sheet.row(row).push m.resume.email
      sheet.row(row).push m.resume.phone
      sheet.row(row).push m.resume.referral_name
      row += 1
    end
  end

  def fill_interview_data(sheet, matches)

    sheet.column(0).width = 30
    sheet.column(1).width = 30
    sheet.column(2).width = 15
    sheet.column(3).width = 10
    sheet.column(4).width = 50
    sheet.column(5).width = 30
    sheet.column(6).width = 30
    sheet.column(7).width = 30

    sheet.row(0).concat %w{Name Req Date Rating Status Email Phone Referral}
    blue = Spreadsheet::Format.new :weight => :bold,
                                   :size   => 12
    sheet.row(0).default_format = blue
    row = 1
    matches.each do |m|
      sheet.row(row).height = 20
      sheet.row(row).push Spreadsheet::Link.new get_resume_url(m.resume.uniqid), m.resume.name
      sheet.row(row).push m.requirement.name
      sheet.row(row).push m.get_display_interview_date
      sheet.row(row).push m.resume.rating
      if m.resume.manual_status
        sheet.row(row).push m.resume.manual_status[0..25]
      else
        sheet.row(row).push ""
      end
      sheet.row(row).push m.resume.email
      sheet.row(row).push m.resume.phone
      sheet.row(row).push m.resume.referral_name
      row += 1
    end
  end

  ####################################################################################################
  # FUNCTIONS   : fill_resume_data                                                                   #
  # DESCRIPTION : Function to be used to fill data for all resumes which are uploaded by HR into xls #
  #             : file.                                                                              #
  ####################################################################################################
 def fill_resume_data(sheet, resume)
  sheet.row(0).concat %w{Name Overall\ Status Recent\ Activity\ On Phone\ Number Email Referral}
    blue = Spreadsheet::Format.new :weight => :bold,
                                   :size   => 12
    sheet.column(0).width = 30
    sheet.column(1).width = 30
    sheet.column(2).width = 30
    sheet.column(3).width = 30
    sheet.column(4).width = 30
    sheet.column(5).width = 30

    sheet.row(0).default_format = blue
    row = 1
    resume.each do |r|
      sheet.row(row).height = 20
      sheet.row(row).push Spreadsheet::Link.new get_resume_url(r.uniqid), r.name
      sheet.row(row).push r.resume_overall_status
      recent_activity       = r.comments.size ? r.comments.last.updated_at : r.updated_at
      sheet.row(row).push recent_activity.strftime('%b %d, %Y')
      sheet.row(row).push r.phone      
      sheet.row(row).push r.email
      sheet.row(row).push r.referral_name
      row += 1
    end
 end

 def fill_forwarded_shortlisted_data(sheet, forwards)
    sheet.row(0).concat %w{Name Education Current\ Company Exp Req Email Phone\ Number Referral}
    blue = Spreadsheet::Format.new :weight => :bold,
                                   :size   => 12
    sheet.column(0).width = 30
    sheet.column(1).width = 50
    sheet.column(2).width = 50
    sheet.column(3).width = 30
    sheet.column(4).width = 30
    sheet.column(5).width = 30
    sheet.column(6).width = 30

    sheet.row(0).default_format = blue
    row = 1
    forwards.each do |fwd|
      sheet.row(row).height = 20
      resume = fwd.resume
      sheet.row(row).push Spreadsheet::Link.new get_resume_url(resume.uniqid), resume.name
      sheet.row(row).push resume.qualification
      sheet.row(row).push resume.current_company
      sheet.row(row).push resume.experience
      if (fwd.class == Forward) 
        req_names = nil
        fwd.requirements.each do |r|
          if req_names.nil?
            req_names = r.name
          else
            req_names += ", #{r.name}"
          end
        end
        sheet.row(row).push req_names
      else
        sheet.row(row).push fwd.requirement.name
      end
      sheet.row(row).push resume.email
      sheet.row(row).push resume.phone
      sheet.row(row).push resume.referral_name
      row += 1 
    end
  end

  ####################################################################################################
  # FUNCTIONS   : EMAIL SENDING FUNCTIONS                                                            #
  # DESCRIPTION : All email sending functions used in resumes controller                             #
  #               For forwarding resume, for adding panel, for taking action, for sending feedback   #
  #               For adding message                                                                 #
  ####################################################################################################
  def email_for_forward_resume(mail_to, resume, uniqid)
    Emailer.forward(get_current_employee,
                            mail_to,
                            resume,
                            uniqid)
    
  end

  def email_for_adding_panel(employee, interview, resume)
    Emailer.panel(employee,
                          interview,
                          resume)
  end

  def email_after_deleting_interview(interview, resume)
    Emailer.removed_panel(interview, resume)
  end

  def email_for_upload(resume)
    if (resume.referral_type == "EMPLOYEE")
      referer = Employee.find(resume.referral_id)
      Emailer.upload(resume, referer)
    end
  end

  def email_for_joined(resume, status = "")
    Emailer.joined(resume, get_current_employee, status)
    if (resume.referral_type == "EMPLOYEE")
      referer = Employee.find(resume.referral_id)
      if (referer.employee_status == "ACTIVE")
        Emailer.joined(resume, referer, status)
      end
      Emailer.joined(resume, get_finance_employee, status)
      Emailer.joined(resume, get_sysadmin_employee, status)
    end
    if (resume.referral_type == "AGENCY")
      Emailer.joined(resume, get_finance_employee, status)
      Emailer.joined(resume, get_sysadmin_employee, status)
    end
  end

  def email_for_action(resume, status, comment, requirement)
    unless requirement.nil?   ||
           requirement == ""
      req_name = requirement.name
    else
      req_name = "No Requirement Specified"
    end
    Emailer.action(get_current_employee,
                                  resume,
                                  req_name,
                                  status,
                                  comment)
  end

  def email_for_feedback(resume, feedback, req)
    Emailer.feedback(get_current_employee,
                             resume,
                             req,
                             feedback)
  end

  def notify_manager_for_panel(req, resume, emp_array)
    Emailer.notify_manager_for_panel(get_current_employee,
                                             req,
                                             resume,
                                             req.employee,
                                             emp_array)
  end

  def email_for_add_message(mesg)
    Emailer.add_message(mesg,
                                get_logged_employee)
  end

  def email_for_decision(resume, requirement, eng_decision, hire_action)
    attachment, filetype = resume.preferred_file
    req_owner = requirement.employee
    gm_for_decision = requirement.employee.gm
    ta_head = requirement.employee.ta_head
    # gm_for_decision = Employee.find_by_login('alokk')
    ta = get_current_employee
    attachment, filetype = resume.preferred_file
    if !attachment
      flash[:notice] = "No resume to attach for #{resume.name}"
      redirect_back(fallback_location: root_path)
    end
    attachment = Rails.root + attachment
    recipients = [gm_for_decision, ta]
    recipients << requirement.ta_lead if requirement.ta_lead
    if eng_decision
      recipients << requirement.eng_lead if requirement.eng_lead
      to = requirement.ta_lead
    else
      to = gm_for_decision
    end
    recipients << ta_head if ta_head
    Emailer.send_for_decision(resume, requirement, to, attachment, filetype, recipients, hire_action)
  end

  def send_email_for_declining(interview)
    for emp in [ interview.employee, interview.req_match.requirement.employee, interview.req_match.resume.employee ]
      Emailer.decline(get_current_employee,
                              emp,
                              interview)
    end
  end

  def error_catching_and_flashing(object)
    unless object.valid?
      object.errors.each { |mesg|
        logger.info(mesg)
        flash[:notice] = mesg.to_s.sub(/is invalid/, "")
      }
    end
    redirect_back(fallback_location: root_path)
  end

  ####################################################################################################
  # FUNCTIONS   : Uniqify Forwards                                                                   #
  # DESCRIPTION : This module will uniqify the forwards based upon resumes                           #
  ####################################################################################################
  def uniqify_forwards(fwds)
    fwds.uniq{ |fwd| fwd.resume }
  end

  ####################################################################################################
  # FUNCTIONS   : get_resume_url                                                                     #
  # DESCRIPTION : Gets the resume url which we write in excel file                                   #
  ####################################################################################################
  def get_resume_url(uniqid)
    url_for(:controller => "resumes", :action => "show", :id => uniqid.name)
  end

  ####################################################################################################
  # FUNCTIONS   : get_current_quarter_resumes                                                        #
  # DESCRIPTION : Gets the resumes of the current quarter                                            #
  ####################################################################################################
  def get_current_quarter_resumes(status)
    resumes = Resume.find_by_sql("select * FROM resumes WHERE resumes.status = \"#{status}\" AND resumes.joining_date >= \"#{Date.today.beginning_of_quarter.to_s}\"")
    resumes  = resumes.sort_by { |r| [!r.joining_date.nil? ?  r.joining_date : Date.today ] }
  end

  def get_current_quarter_resumes_for_offered
    offered_comments = Comment.find_by_sql("select * FROM comments WHERE comments.comment LIKE \"OFFERED%\" AND comments.created_at >= \"#{Date.today.beginning_of_quarter.to_s}\"") 
    offered_comments.uniq{ |c| c.resume }
  end

  def get_quarterly_comments_not_accepted_new(date)
    resumes  = Resume.where(status:"N_ACCEPTED")
    not_accepted_comments = []
    resumes.each do |r|
      next if (date && r.comments.last.created_at < date.beginning_of_quarter)
      comments = []

      if date
      	comments = Comment.find_by_sql("select * FROM comments WHERE comments.resume_id = #{r.id} AND (comments.comment LIKE \"%NOT ACCEPTED%\") AND (comments.created_at >= \"#{date.beginning_of_quarter.to_s}\" AND comments.created_at <= \"#{date.end_of_quarter.to_s}\") ORDER BY created_at DESC") 
      else
      	comments = Comment.find_by_sql("select * FROM comments WHERE comments.resume_id = #{r.id} AND (comments.comment LIKE \"%NOT ACCEPTED%\") ORDER BY created_at DESC") 
      end
      next if comments.size == 0
      not_accepted_comment = comments.first

      comments = Comment.find_by_sql("select * FROM comments WHERE comments.resume_id = #{r.id} AND (comments.comment LIKE \"%OFFERED%\") AND (comments.created_at <= \"#{not_accepted_comment.created_at.to_date.to_s}\") ORDER BY created_at DESC") 
      offered_comment = comments.first

      n_accepted = {}
      n_accepted[:not_accepted] = not_accepted_comment
      n_accepted[:offered] = offered_comment
      not_accepted_comments << n_accepted
    end
    not_accepted_comments.sort_by { |c| c[:not_accepted].created_at }
  end


  def get_quarterly_comments_not_accepted(date)
    resumes  = Resume.find_all_by_status("N_ACCEPTED")
    not_accepted_comments = []
    resumes.each do |r|
      comments = r.comments
      comments.reverse!
      not_accepted_comment = nil
      offered_comment = nil
      comments.each do |c|
        # only interested in last not_accepted 
        if not_accepted_comment == nil && c.comment.include?("NOT ACCEPTED")
          if !date ||
             (c.created_at.month >= date.beginning_of_quarter.month &&
             c.created_at.month <= date.end_of_quarter.month &&
             c.created_at.year  == date.year)
            not_accepted_comment = c
          end
          next
        end
        if not_accepted_comment && c.comment.include?("OFFERED")
          offered_comment = c
          break
        end
      end
      if not_accepted_comment
        n_accepted = {}
        n_accepted[:not_accepted] = not_accepted_comment
        n_accepted[:offered] = offered_comment
        not_accepted_comments << n_accepted
      end
    end
    not_accepted_comments.sort_by { |c| c[:not_accepted].created_at }
  end
end
