class HomeController < ApplicationController
  require 'net/imap'

  # check_for_login redirects to index for login
  before_action :check_for_login, :except => ["index"]
  layout 'login', only: [:index]

  before_action :check_for_ADMIN_or_GM, :only => ["show_summary_per_manager", 
                                            "show_summary_per_recruiter",
                                            "show_summary_per_interviewer"]

  def index
    if get_logged_employee
      redirect_to :controller => "home", :action => "actions_page"
    end
  end

  def actions
    session[:requirement_show_open_div] = nil
    redirect_to :controller => "home", :action => "actions_page"
  end

  def summaries
  end

  
  def interview_panels
      @skills= InterviewSkill.all
      @eids= []
      @skills.each do |skill|
        skill.interviewers.each do |interviewer|
          @eids<<interviewer.eid
        end
      end
      @eids= @eids.uniq
  end

  def actions_page
    if is_HR?
      redirect_to :controller => "home", :action => "dashboard"
    elsif is_ADMIN? || is_REQ_MANAGER?
      redirect_to :controller => "resumes", :action => "manager_index"
    else
      redirect_to :controller => "resumes", :action => "interview_requests"
    end
  end
  def show_summary_per_recruiter
    @sdate = (params[:sdate] && params[:sdate][:sdate]) ? Date.parse(params[:sdate][:sdate]) : Date.today - 7

    @edate = (params[:edate] && params[:edate][:edate]) ? Date.parse(params[:edate][:edate]) : Date.today

    resumes = Resume.all.find_all { |r|
      r.created_at >= @sdate && r.created_at <= @edate
    }
    @recruiter_summary_table = {}
    resumes.each do |r|
      @recruiter_summary_table[r.employee] ||= {
                                  :shortlists => 0, 
                                  :forwards => 0, 
                                  :uploads => 0}
      @recruiter_summary_table[r.employee][:uploads] += 1
      @recruiter_summary_table[r.employee][:forwards] += r.forwards.size
      shortlisted_req_matches = r.req_matches.find_all { |rmatch|
        rmatch.status == "SHORTLISTED" ||
        (!rmatch.interviews.nil? && rmatch.interviews.size > 0)
      }
      @recruiter_summary_table[r.employee][:shortlists] += shortlisted_req_matches.size
    end

    @total_row = {:shortlists => 0, :forwards => 0, :uploads => 0}

    @recruiter_summary_table.each do |e, row|
      @total_row[:shortlists] += row[:shortlists]
      @total_row[:forwards]   += row[:forwards]
      @total_row[:uploads]    += row[:uploads]
    end
  end

  def show_summary_per_manager
    open_reqs = Requirement.open_requirements
    owner_reqs = {}
    open_reqs.each do |r|
      owner_reqs[r.employee] ||= []
      owner_reqs[r.employee] << r
    end

    @owner_summary_table = []
    totalrow = {}
    totalrow[:owner] = "Total"
    totalrow[:positions] = 0
    totalrow[:forwards] = totalrow[:shortlists] = totalrow[:scheduled] = 0
    totalrow[:rejected] = totalrow[:held] = totalrow[:offered] = 0
    totalrow[:joining] = 0

    owner_reqs.each do |o, reqs|
      row = {}
      row[:owner] = o
      get_summary_for_reqs(reqs, row, totalrow)
      @owner_summary_table << row
    end
    @owner_total_row = totalrow

    @req_summary_table = []
    totalrow = {}
    totalrow[:positions] = 0
    totalrow[:forwards] = totalrow[:shortlists] = totalrow[:scheduled] = 0
    totalrow[:rejected] = totalrow[:held] = totalrow[:offered] = 0
    totalrow[:joining] = 0

    open_reqs = Requirement.open_requirements.sort_by {|r| [r.group_id, r.employee_id]}
    open_reqs.each do |req|
      row = {}
      row[:owner] = req
      get_summary_for_reqs([req], row, totalrow)
      @req_summary_table << row
    end
    @req_total_row = totalrow
  end

  def show_summary_per_interviewer
    @sdate = (params[:interviews] && params[:interviews][:sdate]) ? Date.parse(params[:interviews][:sdate]) : Date.today - 30
    @edate = (params[:interviews] && params[:interviews][:edate]) ? Date.parse(params[:interviews][:edate]) : Date.today

    feedbacks = Feedback.all.find_all { |f|
      f.created_at >= @sdate && f.created_at <= @edate
    }
  
    interviews = Interview.all.find_all { |i|
      i.interview_date && 
      (i.interview_date >= @sdate && i.interview_date <= @edate) 
    }

    interviewers_data = {}

    interviews.each do |i|
      interviewers_data[i.employee] ||= {:employee => i.employee,
                                         :ratings => [0, 0, 0, 0, 0],
                                         :average_rating => 0 }
    end                                     

    feedbacks.each do |f|
      interviewers_data[f.employee] ||= {:employee => f.employee,
                                         :ratings => [0, 0, 0, 0, 0],
                                         :average_rating => 0 }
      interviewers_data[f.employee][:ratings][f.numerical_rating - 1] += 1
      interviewers_data[f.employee][:average_rating] += f.numerical_rating
    end

    interviewers_data.each do |e, row| 
      ratings = row[:ratings]
      nratings = 0
      ratings.each do |r|
        nratings += r
      end
      row[:nratings] = nratings
      row[:average_rating] /= nratings if nratings > 0
    end 
      
    @interviewers_data = []
    interviewers_data.each do |e, row|
      ninterviews = e.interviews.find_all { |i| 
        i.interview_date >= @sdate && i.interview_date <= @edate 
      }.size
      row[:interviews] = ninterviews
      @interviewers_data << row
    end
    @interviewers_data = @interviewers_data.sort { |row1, row2| row2[:interviews] <=> row1[:interviews] }
  end

  def classify_resumes(resumes)
    @forwards = []
    @shortlists = []
    @scheduled = []
    @rejected = []
    @holds = []
    @ytos = []
    @eng_selects = []
    @hacs = []
    @offered = []
    @joining = []
    @new = []

    resumes.each do |r|
      case r.overall_status
      when "JOINING"
        @joining << r
      when "OFFERED"  
        @offered << r
      when "YTO"
        @ytos << r
      when "HOLD"
        @holds << r
      when "ENG_SELECT"
        @eng_selects << r
      when "HAC"
        @hacs << r
      when "SCHEDULED"
        @scheduled << r
      when "SHORTLISTED"
        @shortlists << r
      when "FORWARDED"
        @forwards << r
      when "NEW"
        @new << r
      when "REJECTED"
        @rejected << r
      end
    end
  end

  def dashboard
    e = get_current_employee
    resumes = employee_owned_resumes(e)
    classify_resumes(resumes)
    @employee = e
  end

  def dashboard_category
    @status = params[:status]
    e = get_current_employee
    @employee = e
    
    # Initialize variables for resume display
    @resumes = []
    @forwards = []
    @matches = []
    @id_prefix = "dashboard_description_row"
    @counter_value = ""
    @hold_on_req_page = 0
    @offer_on_req_page = 0
    @join_on_req_page = 0
    @after_shortlist_page = false
    
    # Use get_hr_matches for most statuses
    case @status
    when "New"
      @resumes = employee_owned_resumes(e).select { |r| r.overall_status == "NEW" }
      @render = "manager_index"
      @is_req_match = 0
    when "Forwarded"
      @forwards = get_hr_matches("FORWARDED", e)
      @render = "manager_index"
      @is_req_match = 0
    when "Shortlisted"
      @forwards = get_hr_matches("SHORTLISTED", e)
      @render = "manager_index"
      @is_req_match = 1
      @after_shortlist_page = true
    when "Scheduled"
      @matches = get_hr_matches("SCHEDULED", e)
      @interviews_late, @interviews_done, @under_process = ResumesController.find_interviews_status(@matches)
      @render = "interview_table"
      @is_req_match = 1
    when "Scheduled-L1"
      @matches = get_hr_matches("SCHEDULED-L1", e)
      @interviews_late, @interviews_done, @under_process = ResumesController.find_interviews_status(@matches)
      @render = "interview_table"
      @is_req_match = 1
    when "Scheduled-L2"
      @matches = get_hr_matches("SCHEDULED-L2", e)
      @interviews_late, @interviews_done, @under_process = ResumesController.find_interviews_status(@matches)
      @render = "interview_table"
      @is_req_match = 1
    when "Scheduled-L3"
      @matches = get_hr_matches("SCHEDULED-L3", e)
      @interviews_late, @interviews_done, @under_process = ResumesController.find_interviews_status(@matches)
      @render = "interview_table"
      @is_req_match = 1
    when "Completed-L1"
      @matches = get_hr_matches("COMPLETED-L1", e)
      @interviews_late, @interviews_done, @under_process = ResumesController.find_interviews_status(@matches)
      @render = "interview_table"
      @is_req_match = 1
    when "Completed-L2"
      @matches = get_hr_matches("COMPLETED-L2", e)
      @interviews_late, @interviews_done, @under_process = ResumesController.find_interviews_status(@matches)
      @render = "interview_table"
      @is_req_match = 1
    when "Completed-L3"
      @matches = get_hr_matches("COMPLETED-L3", e)
      @interviews_late, @interviews_done, @under_process = ResumesController.find_interviews_status(@matches)
      @render = "interview_table"
      @is_req_match = 1
    when "HAC"
      @matches = get_hr_matches("HAC", e)
      @render = "interview_table"
      @is_req_match = 1
    when "Rejected"
      @forwards = get_hr_matches("REJECTED", e)
      @render = "manager_index"
      @is_req_match = 1
      @after_shortlist_page = true
    when "Hold"
      @matches = get_hr_matches("HOLD", e)
      @render = "interview_table"
      @hold_on_req_page = 1
      @is_req_match = 1
    when "Offered"
      @matches = get_hr_matches("OFFERED", e)
      @render = "joining_offered_hold_form"
      @offer_on_req_page = 1
      @is_req_match = 1
    when "Yto"
      @matches = get_hr_matches("YTO", e)
      @interviews_late, @interviews_done, @under_process = ResumesController.find_interviews_status(@matches)
      @render = "interview_table"
      @is_req_match = 1
    when "Joining"
      @matches = get_hr_matches("JOINING", e)
      @render = "joining_offered_hold_form"
      @join_on_req_page = 1
      @is_req_match = 1
    when "Not Joined"
      @matches = get_hr_matches("NOT JOINED", e)
      @render = "manager_index"
      @is_req_match = 1
    when "Not Accepted"
      @matches = get_hr_matches("NOT ACCEPTED", e)
      @render = "manager_index"
      @is_req_match = 1
    when "Eng Select"
      @matches = get_hr_matches("ENG_SELECT", e)
      @render = "manager_index"
      @is_req_match = 1
    end
    
    # Convert forwards to resumes for display
    @forwards.each do |f| 
      @resumes.push(f.resume)
    end
    
    @resumes.uniq!
    
    # Handle AJAX requests
    if request.xhr?
      render partial: "dashboard_category"
    else
      render partial: "dashboard_category"
    end
  end
 
private
  def get_summary_for_reqs(reqs, row, totalrow)
    row[:positions]  =  reqs.inject(0) { |result, req| result + req.nop }
    totalrow[:positions] += row[:positions]

    row[:forwards]   = reqs.inject(0) { |result, req| result + req.open_forwards.size }
    totalrow[:forwards] += row[:forwards]
    row[:shortlists] = reqs.inject(0) { |result, req| result + req.shortlists.size }
    totalrow[:shortlists] += row[:shortlists]
    row[:scheduled]  = reqs.inject(0) { |result, req| result + req.scheduled.size }
    totalrow[:scheduled] += row[:scheduled]
    row[:rejected]   = reqs.inject(0) { |result, req| result + req.rejected.size }
    totalrow[:rejected] += row[:rejected]
    row[:held]       = reqs.inject(0) { |result, req| result + req.hold.size }
    totalrow[:held] += row[:held]
    row[:offered]    = reqs.inject(0) { |result, req| result + req.offered.size }
    totalrow[:offered] += row[:offered]
    row[:joining]    = reqs.inject(0) { |result, req| result + req.joining.size }
    totalrow[:joining] += row[:joining]
  end

end
