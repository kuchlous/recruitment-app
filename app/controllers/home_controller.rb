class HomeController < ApplicationController
  require 'net/imap'

  # check_for_login redirects to index for login
  # before_filter :check_for_login, :except => ["index"]

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

  def actions_page
    if true
      redirect_to :controller => "home", :action => "dashboard"
    elsif is_ADMIN? || is_REQ_MANAGER?
      redirect_to :controller => "resumes", :action => "manager_index"
    else
      redirect_to :controller => "resumes", :action => "interview_requests"
    end
  end

  def search
    @results = ""
    unless params[:search].nil?
      @search_text  = params[:search][:box]
      session[:search_text] = @search_text
    else
      @search_text  = session[:search_text]
    end

    query = @search_text

    @results = Resume.search(query, :field_weights => {:name => 10}, :page => params[:page], :per_page => get_per_page)
    puts @results
  end

  def advanced_search
  end

  def advanced_search_results
    @resume = Resume.new
    @results = ""
    @search_text = params[:search]
    @ctc_min = params[:ctc_min] ? params[:ctc_min].to_f * 1.0 : 0.0
    @ctc_max = params[:ctc_max] ? params[:ctc_max].to_f * 1.0 : 1000.0
    @ctc_max = 1000.0 if @ctc_max < @ctc_min || @ctc_max == 0
    @expected_ctc_min = params[:expected_ctc_min] ? params[:expected_ctc_min].to_f * 1.0 : 0.0
    @expected_ctc_max = params[:expected_ctc_max] ? params[:expected_ctc_max].to_f * 1.0 : 1000.0
    @expected_ctc_max = 1000.0 if @expected_ctc_max < @expected_ctc_min || @expected_ctc_max == 0
    @status = params[:status]
    @status = nil if @status == "Any"
    @experience_months_min = 0
    if (params[:experience_years_min] || params[:experience_months_min])
      @experience_months_min += params[:experience_years_min].to_i * 12 if params[:experience_years_min]
      @experience_months_min += params[:experience_months_min].to_i if params[:experience_months_min]
    end
    @experience_months_max = 1000
    if (params[:experience_years_max] || params[:experience_months_max])
      @experience_months_max = 0
      @experience_months_max += params[:experience_years_max].to_i * 12 if params[:experience_years_max]
      @experience_months_max += params[:experience_months_max].to_i if params[:experience_months_max]
    end
    @experience_months_max = 1000 if @experience_months_max < @experience_months_min || @experience_months_max == 0
    @requirement = params[:requirement]
    @requirement = nil if @requirement == '0'
    conditions = {}
    conditions[:related_requirements] = @requirement if @requirement
    conditions[:overall_status] = @status if @status
    logger.info("search = " + @search_text + "ctc_min = " + @ctc_min.to_s  + "ctc_max = " + @ctc_max.to_s + "expected_ctc_min = " + @expected_ctc_min.to_s + "expected_ctc_max = " + @expected_ctc_max.to_s + "experience_months_min = " + @experience_months_min.to_s + "experience_months_max = " + @experience_months_max.to_s) 
    @results = Resume.search(@search_text, :field_weights => {:name => 10}, :page => params[:page], :per_page => get_per_page, 
                             :with => {:ctc => @ctc_min..@ctc_max, 
                                       :expected_ctc => @expected_ctc_min..@expected_ctc_max,
                                       :exp_in_months => @experience_months_min..@experience_months_max},
                             :conditions => conditions
                            )
  end

  def show_summary_per_recruiter
    @sdate = (params[:sdate] && params[:sdate][:sdate]) ? Date.parse(params[:sdate][:sdate]) : Date.today - 7

    @edate = (params[:edate] && params[:edate][:edate]) ? Date.parse(params[:edate][:edate]) : Date.today

    resumes = Resume.find(:all).find_all { |r|
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
      resume_overall_status = r.resume_overall_status
      if resume_overall_status == "Joining Date Given"
        @joining << r
      elsif resume_overall_status == "Offered"
        @offered << r
      elsif resume_overall_status == "Yet To Offer"
        @ytos << r
      elsif resume_overall_status == "On Hold"
        @holds << r
      elsif resume_overall_status == "Engg. Select"
        @eng_selects << r
      elsif resume_overall_status == "HAC"
        @hacs << r
      elsif resume_overall_status == "Interview Scheduled"
        @scheduled << r
      elsif resume_overall_status == "Shortlisted"
        @shortlists << r
      elsif resume_overall_status == "Forwarded"
        @forwards << r
      elsif resume_overall_status == "New"
        @new << r
      elsif resume_overall_status == "Rejected"
        @rejected << r
      end
    end
   end

  def dashboard
    e = get_current_employee
    resumes = get_employee_referred_resumes(e)
    classify_resumes(resumes)
    @employee = e
    status = params[:status]
    if status == "New"
      @resumes = @new
    elif status == "Forwards"
      @resumes = @forwards
      @render  = "manager_index"
      @forwards = []
      @resumes.each do |r|
        @forwards += r.forwards
      end
      @is_req_match  = 0
    elif status == "Shortlisted"
      @resumes = @shortlists
      @render  = "manager_index"
      @forwards = []
      @resumes.each do |r|
        @forwards += r.req_matches
      end
      @is_req_match  = 1
    elif status == "Scheduled"
      @resumes = @scheduled
      @matches = []
      @resumes.each do |r|
        @matches += r.req_matches.find_all { |r|
          r.status == "SCHEDULED" &&
          r.resume.resume_overall_status != "Future"
        }
      end
      @interviews_late, @interviews_done, @under_process = ResumesController.find_interviews_status(@matches)
      @is_req_match  = 1
    elif status == "Rejected"
      @resumes = @rejected
      @is_req_match  = 1
      @forwards = []
    elif status == "Hold"
      @resumes = @holds
      @is_req_match  = 1
    elif status == "YTO"
      @resumes = @ytos
      @is_req_match  = 1
    elif status == "Engg. Select"
      @resumes = @eng_selects
      @is_req_match  = 1
    elif status == "HAC"
      @resumes = @hacs
      @is_req_match  = 1
    elif status == "Offered"
      @resumes = @offered
      @is_req_match  = 1
    elif status == "Joining"
      @resumes = @joining
      @is_req_match  = 1
    end
    @status = status
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
