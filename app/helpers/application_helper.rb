# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def get_employee_from_id(id)
    Employee.find(id)
  end

  def get_logged_employee
    Employee.find(session[:logged_employee_id])
  end

 def get_current_employee
    if (session[:current_employee_id] == nil)
      session[:current_employee_id] = session[:logged_employee_id]
    end
    employee = Employee.find_by_id(session[:current_employee_id])
  end

  def is_HR?
    logged_employee = get_current_employee
    logged_employee.is_HR?
  end

  def is_MANAGER?
    logged_employee = get_current_employee
    logged_employee.is_MANAGER?
  end
    

  def is_ADMIN?
    logged_employee = get_current_employee
    logged_employee.is_ADMIN?
  end

  def is_HR_ADMIN?
    is_HR? || is_ADMIN?
  end

  def is_HR_MANAGER?
    is_HR? && is_MANAGER?
  end

  def is_REQ_MANAGER?
    logged_employee = get_current_employee
    logged_employee.is_REQ_MANAGER?
  end

  def is_PM?
    logged_employee = get_current_employee
    logged_employee.is_PM?
  end

  def is_GM?
    logged_employee = get_current_employee
    logged_employee.is_GM?
  end

  def is_BD?
    logged_employee = get_current_employee
    logged_employee.is_BD?
  end

  def get_forwards_of_status(status)
    forwards = get_current_employee.forwards.find_all {
      |fwd| fwd.status == status
    }
    forwards
  end

  def get_req_matches_of_status(status)
    req_matches = get_current_employee.req_matches.find_all {
      |match| match.status == status
    }
    req_matches += get_current_employee.forwards.find_all {
      |fwd| fwd.status == status
    }
  end

  def get_resume_req_matches_of_employee(resume, status)
    req_matches = resume.req_matches.find_all { |r|
      r.status   == status &&
      r.requirement.employee == get_current_employee
    }
    req_matches += resume.forwards.find_all { |r|
      r.status       == status &&
      r.forwarded_to == get_current_employee
    }
  end

  def get_resumes_of_employee_requirement(status)
    req_match_array  = []
    resume_array     = []
    resumes          = []
    # Find open requirements of employees
    open_employee_reqs    = get_current_employee.requirements.all.find_all {
      |r| r.status   == "OPEN"
    }
    # Find req_matches of employee requirements
    open_employee_reqs.each do |r|
      req_match_array += r.req_matches
    end
    # Find resume of the employee requirements
    i = 0
    while i < req_match_array.size
      resume_array    << req_match_array[i].resume if req_match_array[i].status == status
      i = i + 1
    end
    # Resumes in an array
    resume_array.each do |r|
      resumes << r
    end

    # Uniqifying resumes
    resumes.uniq

  end

  def get_req_matches(resume)
    matches_array = []
    matches = resume.req_matches
    matches.each do |match|
      matches_array << match.requirement.id
      matches_array << match.id
    end
    matches_array
  end

  def get_admin_forwards_of_status(status)
    forwards = Forward.all.find_all { |f|
      f.status == status
    }
    forwards += ReqMatch.all.find_all { |m|
      m.status == status
    }
  end

  def get_all_req_matches_of_status(status)
    matches = ReqMatch.all.find_all { |m|
      m.status == status
    }
    matches.sort_by { |m| [m.requirement.name]}
  end

  def get_admin_resumes_of_status(status)
    if (status == "NEW")
      resumes = Resume.find_by_sql("SELECT * FROM resumes WHERE resumes.status = \"\" AND resumes.nforwards = 0 AND resumes.nreq_matches = 0")
      new_resumes = Resume.find_all_by_status("NEW")
      resumes += new_resumes
      return resumes
    end

    resumes = Resume.all.find_all { |resume|
      resume.resume_overall_status == status.titleize
    }
  end

  def get_resume_forwards_and_req_matches(resume)
    fwds_and_matches  = resume.forwards
    fwds_and_matches += resume.req_matches
  end

  def get_resume_forwards(resume)
    forwards = []
    forwards = resume.forwards.find_all { |f|
                 f.status == "FORWARDED"
               }
    forwards
  end

  def get_resume_req_matches(resume, status)
    matches  = []
    matches  = resume.req_matches.find_all { |r|
                 r.status == status
               }
    matches
  end

  def get_actions_drop_down(status)
    actions_arr = []
    actions_arr.push(["Other actions"])
    actions_arr.push(["Add Comment"])
    actions_arr.push(["Forward to"])
    actions_arr.push(["Message"])
    unless status == "FORWARDED"
      unless params[:action] == "forwarded"
        if is_HR? || is_ADMIN? || is_REQ_MANAGER?
          for action in [ "Set Status", "Interviews", "Yet to Offer", "Reject", "Mark Hold", "Mark Offered", "Mark Joining" ]
            actions_arr.push([action])
          end
        else
          if status == "FORWARDED"
            actions_arr.push(["Interviews"])
          else
            for action in [ "Set Status", "Yet to Offer", "Reject", "Mark Hold", "Mark Offered", "Mark Joining" ]
              actions_arr.push([action])
            end
          end
        end
      end
    end

    actions_arr
  end

  def get_manager_actions_drop_down(is_shortlist_page)
    acts = [["Select"], ["Add Comment"], ["Forward to"], ["Message"]]
    if !is_shortlist_page
      acts << ["Shortlist"]
    else
      acts << ["Interviews"]
    end
    acts += [["YTO"], ["Reject"], ["Hold"], ["Offer"], ["Joining"]]
  end

  def status_array
    status_arr = []
    for status in [ "FORWARDED" ]
      status_arr << status
    end
    if is_HR? || is_ADMIN? || is_REQ_MANAGER?
      for status in [ "SHORTLISTED" ]
        status_arr << status
      end
    end
    status_arr
  end

  def get_admin_status_array
    admin_status_arr = []
    for status in [ "NEW", "FORWARDED", "SHORTLISTED" ]
      admin_status_arr << status
    end
  end

  def get_row_id_prefix(istatus)
    row_id_prefix = ""
    if istatus == "NEW"
      row_id_prefix = "new_resume_row"
    elsif istatus == "FORWARDED"
      row_id_prefix = "forwarded_resume_row"
    elsif istatus == "SHORTLISTED"
      row_id_prefix = "shortlisted_resume_row"
    end
    row_id_prefix
  end

  def get_referral_name(ref_type, ref_id)
    ref_name = ""
    if (ref_id == 0)
      return ref_name
    end
    if ref_type    == "EMPLOYEE"
      ref_name     = Employee.find(ref_id)
    elsif ref_type == "PORTAL"
      ref_name     = Portal.find(ref_id)
    else
      ref_name     = Agency.find(ref_id)
    end
    ref_name
  end

  def get_experience_years
    exp_array = []
    for i in 0..15
      exp_array << i
    end
  end

  def get_experience_months
    exp_array = []
    for i in 0..12
      exp_array << i
    end
  end

  def get_year_month_of_experience(resume)
    year  = 0
    month = 0

    unless resume.experience.nil?
      year = @resume.experience.split("-")[0]
      month = @resume.experience.split("-")[1]
    end
    [ year, month ]
  end

  def get_number_positions_ddl_values
    val_array = []
    limit     = APP_CONFIG['number_positions']
    for i in 1..limit
      val_array << i
    end
  end

  def all_reqs_names( prompt_var = nil)
    req_name_array = []
    unless prompt_var == 1
      req_name_array << "Select requirement"
    end
    all_active_reqs = Requirement.find_by_sql("SELECT name FROM requirements WHERE STATUS = \"OPEN\" ORDER BY name")
    req_name_array += all_active_reqs.map{|r| r.name.gsub(/'|"/, '')}
    req_name_array
  end

  def all_reqs_ids(prompt_var = nil)
    req_ids_array = []
    unless prompt_var == 1
      req_ids_array << nil
    end
    all_active_reqs = Requirement.find_by_sql("SELECT id FROM requirements WHERE STATUS = \"OPEN\" ORDER BY name")
    req_ids_array += all_active_reqs.map{|r| r.id}
    req_ids_array
  end

  def all_record_names(ifield)
    name_array = []
    if ifield == "Employee"
      all_active_emps = Employee.find_by_sql("SELECT name FROM employees WHERE EMPLOYEE_STATUS = \"ACTIVE\" ORDER BY name")
      name_array = all_active_emps.map{|e| e.name}
    else
      ifield.constantize.all.each do |e|
        name_array << e.name
      end
    end
    name_array
  end

  def all_record_ids(ifield)
    id_array = []
    if ifield == "Employee"
      all_active_emps = Employee.find_by_sql("SELECT id FROM employees WHERE EMPLOYEE_STATUS = \"ACTIVE\" ORDER BY name")
      id_array = all_active_emps.map{|e| e.id}
    else
      ifield.constantize.all.each do |e|
        id_array << e.id
      end
    end
    id_array
  end

  def all_group_reqs_ids(igroup)
    group_req_ids  = []
    group_req_ids  << nil
    all_reqs = Requirement.all(:order => "name").find_all {
      |req| req.group.name  == igroup &&
            req.status      == "OPEN"
    }
    all_reqs.each do |req|
      group_req_ids << req.id
    end
    group_req_ids
  end

  def all_group_reqs_names(igroup)
    group_req_names = []
    group_req_names << "Select all #{igroup.downcase} reqs"
    all_reqs = Requirement.all(:order => "name").find_all {
      |req| req.group.name  == igroup &&
            req.status      == "OPEN"
    }
    all_reqs.each do |req|
      group_req_names << req.name
    end
    group_req_names
  end

  def all_reqs_names_of_an_manager
    manager_req_name_array = []
    logged_employee = get_current_employee
    manager_reqs     = Requirement.all.find_all {
      |req| req.status   == "OPEN" &&
            req.employee == logged_employee
    }
    manager_reqs.each do |req|
      manager_req_name_array << req.name
    end
    manager_req_name_array
  end

  def all_reqs_ids_of_an_manager
    manager_req_id_array = []
    logged_employee = get_current_employee
    manager_requirements = Requirement.all.find_all {
      |req| req.status   == "OPEN" &&
            req.employee == logged_employee
    }
    manager_requirements.each do |req|
      manager_req_id_array << req.id
    end
    manager_req_id_array
  end

  def print_date_no_year(idate)
    if idate
      idate.strftime('%b %d')
    else
      return "No Date"
    end
  end

  def print_date(idate)
    if idate
      idate.strftime('%b %d, %Y')
    else
      return "No Date Specified"
    end
  end

  def print_date_and_time_and_year(idate)
    idate.strftime('%b %d, %Y (%I:%M %P)')
  end

  def print_date_and_time(idate)
    idate.strftime('%b %d (%I:%M %P)')
  end

  def print_month_and_year(idate)
    idate.strftime('%b %y');
  end

  def date_in_calendar_format(idate)
    if idate
      idate.strftime('%B %d, %Y')
    else
      return ""
    end
  end

  def print_time(itime)
    itime.strftime("%I:%M%p")
  end

  def date_in_database_format(idate)
    idate.strftime('%Y-%m-%d')
  end

  def remove_extra_characters(istring)
    istring.sub(/[^\w\+\.\@]/, '')
  end

  def snippet(text, wordcount)
    rval = ""
    if text.size.to_i < 16
      rval = text
    else
      rval = text.split[0..(wordcount-1)].join(" ") + (text.split.size > wordcount ? "..." : "")
    end
    rval
  end

  def get_words(text, wordcount)
    rval = ""
    if text != nil
      rval = text.split[0..(wordcount-1)].join(" ")
    end
    rval
  end

  def get_characters(text, number)
    text.size.to_i > 22 ? ( text[0..number] + ".." ) : text
  end

  def get_current_experience_string(resume)
    year, month = resume.get_current_experience 
    "#{year}-#{month}"
  end

  def resume_link_with_20_characters(resume)
    company = resume.current_company ? resume.current_company : ""
    uniqid_name = resume.uniqid.name;
    link_to get_characters(resume.name.titleize, 17), {:host=> APP_CONFIG['host_name'], :controller  => "resumes", :action => "show", :id => uniqid_name },
                                               :onMouseOver => "popUpDescriptionForResume(#{resume.id}, \"#{snippet(resume.qualification, 10)}\", \"#{get_current_experience_string(resume)}\", \"#{company}\");",
                                               :onMouseOut  => "HideContent(\"#{resume.id}\");",
                                               :onClick     => "openResumeInNewTab(\"#{uniqid_name}\"); return false;"
  end

  def get_view_comments_icon(resume, cols=4)
    link_to_function image_tag("ViewComments.png", :size    => "20x20",
                                                   :class   => "view_icon_class",
                                                   :title   => "View all comments for this resume"),
                                                   :onclick => "viewCommentsFeedback(event, #{resume.id}, 'show_resume_comments', #{cols});"
                 
  end

  def get_view_feedback_icon(resume, cols=4)
    link_to_function image_tag("ViewFeedback.png", :size    => "20x20",
                                                   :class   => "feedback_icon_class",
                                                   :title   => "View all feedback for this resume"),
                                                   :onclick => "viewCommentsFeedback(event, #{resume.id}, 'show_resume_feedback', #{cols});"
  end

  def get_actions_ddl(resume, req_match, status)
    select_tag "actions_name", options_for_select(get_actions_drop_down(status)),
                                                  :class    => "actions_drop_down_list_small",
                                                  :onchange => "actionBox(this.value, event, all_req_ids,
                                                                                             all_req_names,
                                                                                               #{req_match.id},
                                                                                               #{resume.id});"
  end

  def get_manager_actions_dropdownlist(resume, fwd, counter_value, is_shortlist_page = false)
    select_tag "manager_actions_name#{counter_value}", options_for_select(get_manager_actions_drop_down(is_shortlist_page)),
                                                       :class    => "manager_actions_drop_down_list",
                                                       :onchange => "actionBoxManager(this.value, event, all_req_ids,
                                                                                                         all_req_names,
                                                                                                           #{fwd.id},
                                                                                                           #{resume.id}, #{is_shortlist_page});"
  end

  # To be used in manage_interviews
  def get_time_slot_array
    time_slot_array = ["07:00", "07:30", "08:00", "08:30", "09:00", "09:30", "10:00", "10:30",
                       "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30",
                       "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30",
                       "19:00", "19:30", "20:00", "20:30", "21:00"]
  end

  def get_resume_link_with_mouse_over_and_mouseout(resume)
    return '' unless resume
    company      = resume.current_company ? resume.current_company : ""
    uniqid_name  = resume.uniqid.name
    link_to resume.name, { :controller  => "resumes", :action => "show", :host => APP_CONFIG['host_name'], :id => uniqid_name },
                           :onMouseOver => "popUpDescriptionForResume(#{resume.id}, \"#{snippet(resume.qualification, 10)}\", \"#{get_current_experience_string(resume)}\", \"#{company}\");",
                           :onMouseOut  => "HideContent(\"#{resume.id}\");",
                           :onClick     => "openResumeInNewTab(\"#{uniqid_name}\"); return false;"
  end

  def get_requirement_link_with_mouse_over_and_mouseout(requirement)
    s = requirement.skill
    if ! s.valid_encoding?
      s = s.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
    end
    d = requirement.description
    if ! d.valid_encoding?
      d = d.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
    end

    link_to requirement.name, {:host=> APP_CONFIG['host_name'], :controller  => "requirements", :action => "show", :id => requirement.id },
                                :onMouseOver => "popUpDescriptionForRequirements(#{requirement.id}, \"#{s}\", \"#{d}\");",
                                :onMouseOut  => "HideContent(\"#{requirement.id}\");"
    # link_to requirement.name, {:controller  => "requirements", :action => "show", :id => requirement.id}
  end

  def get_reqmatches_resumes(matches)
    resumes = []
    matches.each do |f|
      resumes.push(f.resume)
    end
    resumes.uniq
  end

  def get_forwards_resumes(forwards)
    resumes = []
    forwards.each do |f|
      resumes.push(f.resume)
    end
    resumes.uniq
  end

  def get_start_end_month(cur_month, span)
    span_no = (cur_month - 1) / span
    start_month = ( span_no - 1 ) * span + 1
    end_month = start_month + (span - 1)
    [span_no, start_month, end_month]
  end

  def get_month_str(start_month, end_month)
    month_str = ""
    if start_month != end_month
      month_str = Date::ABBR_MONTHNAMES[start_month] + ".." + Date::ABBR_MONTHNAMES[end_month]
    else
      month_str = Date::ABBR_MONTHNAMES[start_month]
    end
  end

  def get_year_str(start_month, end_month)
    year_str = ""
    if start_month != end_month
      year_str = Date::MONTHNAMES[start_month] + ".." + Date::MONTHNAMES[end_month]
    else
      year_str = Date::MONTHNAMES[start_month]
    end
  end

  def get_req_match_requirement(resume, status)
    matches = resume.req_matches
    matches.each do |match|
      if match.status == status
        return get_requirement_link_with_mouse_over_and_mouseout(match.requirement)
      end
    end
  end

  def get_resume_requirement(resume, status)
    matches = resume.req_matches
    matches.each do |match|
      if match.resume.status == status
        return get_requirement_link_with_mouse_over_and_mouseout(match.requirement)
      end
    end
  end

  def get_requirement_from_comment(comment, status)
    req = nil
    if (comment && /#{status}/.match(comment.comment))
      forindex = comment.comment.rindex("for ")
      if (forindex)
        ssize = comment.comment.size
        rnameindex = forindex + 4
        rname = comment.comment[rnameindex..ssize]
        req = Requirement.find_by_name(rname)
      end
    end
    req
  end

  def include_google_api
    extras  = RAILS_ENV == "development" ? "{ uncompressed: true }" : "{}"
    string  = "<script src=\"https://www.google.com/jsapi\" type=\"text/javascript\"> </script>"
    string += "<script type=\"text/javascript\">"
    string += "google.load(\"prototype\", \"1.7.0.0\", " + extras + ");"
    string += "google.load(\"jquery\",    \"1.7.1\",   " + extras + ");"
    string += "google.load(\"jqueryui\",  \"1.8.16\",  " + extras + ");"
    string += "</script>"
  end

  def include_internal_files
    string  = javascript_include_tag"/optional-js/prototype.js"
    string += javascript_include_tag"/optional-js/jquery.js"
    string += javascript_include_tag"/optional-js/jquery-ui.js"
  end

  def load_google_api_or_internal_files_based_upon_ip_address
    client_ip_address = request.remote_ip
    load_google_api   = false
    unless ( /127.0.0.1/.match(client_ip_address) ||
             /192.168.1./.match(client_ip_address) )
      load_google_api = true
    end

    if load_google_api
      include_google_api
    else
      include_internal_files
    end
  end

  def get_ajax_request_for_quarterly_joined(smonth, emonth, year, status, text)
    status == "JOINED" ? div = "joined_resumes_div" : div = "not_joined_resumes_div"
    link_to_remote "#{text}(#{Date::ABBR_MONTHNAMES[smonth]} .. #{Date::ABBR_MONTHNAMES[emonth]})", :url => { :host=> APP_CONFIG['host_name'], :controller => "resumes", :action => "show_quarterly_joined", :smonth => smonth, :emonth => emonth, :year => year, :status => status }, :update => "#{div}"
  end

  def get_ajax_request_for_all_joined_or_not_joined(text, status)
    status == "JOINED" ? div = "joined_resumes_div" : div = "not_joined_resumes_div"
    link_to_remote text, :url => { :host=> APP_CONFIG['host_name'], :controller => "resumes", :action => "show_all_joined_or_not_joined", :status => status }, :update => "#{div}"
  end

  def get_ajax_request_for_quarterly_offered(smonth, emonth, year, status, text)
    div    = "offered_resumes_div"
    link_to_remote "#{text}(#{Date::ABBR_MONTHNAMES[smonth]} .. #{Date::ABBR_MONTHNAMES[emonth]})", :url => { :host=> APP_CONFIG['host_name'], :controller => "resumes", :action => "show_quarterly_offered", :smonth => smonth, :emonth => emonth, :year => year, :status => status }, :update => "#{div}"
  end

  def get_ajax_request_for_all_offered(text, status)
    div    = "offered_resumes_div"
    link_to_remote text, :url => { :host=> APP_CONFIG['host_name'], :controller => "resumes", :action => "show_all_offered", :status => status }, :update => "#{div}"
  end

  def get_ajax_request_for_quarterly_not_accepted(smonth, emonth, year, status, text)
    div    = "not_accepted_resumes_div"
    link_to_remote "#{text}(#{Date::ABBR_MONTHNAMES[smonth]} .. #{Date::ABBR_MONTHNAMES[emonth]})", :url => { :host=> APP_CONFIG['host_name'], :controller => "resumes", :action => "show_quarterly_not_accepted", :smonth => smonth, :emonth => emonth, :year => year, :status => status }, :update => "#{div}"
  end

  def get_ajax_request_for_all_not_accepted(text, status)
    div    = "not_accepted_resumes_div"
    link_to_remote text, :url => { :host=> APP_CONFIG['host_name'], :controller => "resumes", :action => "show_all_not_accepted", :status => status }, :update => "#{div}"
  end
end
