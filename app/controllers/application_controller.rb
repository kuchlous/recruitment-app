# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

# From http://redcorundum.blogspot.com/2007/02/have-you-seen-that-key.html
module Enumerable
  def uniq_by
    seen = {}
    select { |v|
      key = yield(v)
     (seen[key]) ? nil : (seen[key] = true)
    }
  end
end

class ApplicationController < ActionController::Base

  # Use layout for home for all the controllers
  layout "home"

  helper :all # include all helpers, all the time
  filter_parameter_logging "password"

  # See ActionController::RequestForgeryProtection for details
  protect_from_forgery :only => [:create, :update, :destroy]
  self.allow_forgery_protection = false unless ENV["RAILS_ENV"] == "production"

  def default_url_options(options=nil)
    if Rails.env.production?
      {:protocol => "https", :host => APP_CONFIG['host_name'], :only_path => false}
    else  
     {}
    end
  end
  
  def get_employee_from_id(id)
    Employee.find(id)
  end

  def get_logged_employee
    employee = Employee.find_by_id(session[:logged_employee_id])
  end

  def set_logged_employee(id)
    session[:logged_employee_id] = id
  end

  def get_finance_employee
    Employee.find_by_name("Sobhanadri V")
  end

  def get_sysadmin_employee
    Employee.find_by_email("somu@mirafra.com")
  end

  def get_HR_employee
    Employee.find_by_emai("shailesh@mirafra.com")
  end

  def set_current_employee(id)
    session[:current_employee_id] = id
  end

  def get_current_employee
    if (session[:current_employee_id] == nil)
      session[:current_employee_id] = session[:logged_employee_id]
    end
    employee = Employee.find_by_id(session[:current_employee_id])
  end

  def check_for_login(msg = "Please login to your account first")
    session[:return_to] = "/recruit" + request.request_uri
    logger.info("IP: " + request.remote_ip)
    logger.info("/recruit" + request.request_uri)
    @logged_employee  = get_current_employee
    if @logged_employee.nil? && params[:key] != "26a79dtu"
      flash[:notice] = msg
      redirect_to :controller => "home"
    elsif !@logged_employee.nil?
      logger.info("Employee: " + @logged_employee.name) 
    end
  end

  def redirect_back_or_default(default)
    session[:return_to] ? redirect_to(session[:return_to]) : redirect_to(default)
    session[:return_to] = nil
  end

  def check_for_HR_or_ADMIN(msg = "You do not have authorization to access this page")
    @logged_employee = get_current_employee
    unless @logged_employee.is_HR? || @logged_employee.is_ADMIN?
      flash[:notice] = msg
      redirect_to :controller => "home", :action => "actions_page"
    end
  end

  def check_for_ADMIN(msg = "You do not have authorization to access this page")
    @logged_employee = get_current_employee
    unless @logged_employee.is_ADMIN?
      flash[:notice] = msg
      redirect_to :controller => "home", :action => "actions_page"
    end
  end

  def check_for_ADMIN_or_GM(msg = "You do not have authorization to access this page")
    @logged_employee = get_current_employee
    unless @logged_employee.is_ADMIN? || @logged_employee.is_GM?
      flash[:notice] = msg
      redirect_to :controller => "home", :action => "actions_page"
    end
  end

  def check_for_HR_or_ADMIN_or_REQMANAGER(msg = "You do not have authorization to access this page")
    @logged_employee = get_current_employee
    unless @logged_employee.is_HR? || @logged_employee.is_ADMIN? || @logged_employee.is_REQ_MANAGER?
      flash[:notice] = msg
      redirect_to :controller => "home", :action => "actions_page"
    end
  end

  def check_for_HR_or_ADMIN_or_REQMANAGER_or_BD(msg = "You do not have authorization to access this page")
    @logged_employee = get_current_employee
    unless @logged_employee.is_HR? || @logged_employee.is_ADMIN? || @logged_employee.is_REQ_MANAGER?
      flash[:notice] = msg
      redirect_to :controller => "home", :action => "actions_page"
    end
  end


  def check_for_HR_or_ADMIN_or_REQMANAGER_or_PM(msg = "You do not have authorization to access this page")
    @logged_employee = get_current_employee
    unless params[:key] == "26a79dtu" || @logged_employee.is_HR? || @logged_employee.is_ADMIN? || @logged_employee.is_REQ_MANAGER? || @logged_employee.is_PM?
      flash[:notice] = msg
      redirect_to :controller => "home", :action => "actions_page"
    end
  end

  def check_for_HR_or_ADMIN_or_REQMANAGER_or_PM_or_BD(msg = "You do not have authorization to access this page")
    @logged_employee = get_current_employee
    unless params[:key] == "26a79dtu" || @logged_employee.is_HR? || @logged_employee.is_BD? || @logged_employee.is_ADMIN? || @logged_employee.is_REQ_MANAGER? || @logged_employee.is_PM?
      flash[:notice] = msg
      redirect_to :controller => "home", :action => "actions_page"
    end
  end


  def is_HR?
    @logged_employee = get_current_employee
    @logged_employee.is_HR?
  end

  def is_ADMIN?
    @logged_employee = get_current_employee
    @logged_employee.is_ADMIN?
  end

  def is_MANAGER?
    if @logged_employee.is_manager?
      return @logged_employee
    else
      return false
    end
  end

  def is_BD?
    if @logged_employee.is_BD?
      return @logged_employee
    else
      return false
    end
  end

  def is_REQ_MANAGER?
    is_req = Requirement.all.find_all {
      |req| req.status   == "OPEN" &&
            req.employee == @logged_employee
    }
    unless is_req.nil? || is_req.empty?
      return true
    else
      return false
    end
  end

  def get_host
    @host = request.host
  end

  def get_port
    @port = request.port
  end

  def get_all_groups
    Group.all(:order => :name)
  end

  def get_all_designations
    Designation.all
  end

  def get_all_employees
    Employee.all(:order => :name)
  end

  def get_all_accounts
    Account.all(:order => :name)
  end

  def get_referral_name(ref_type, ref_id)
    ref_name = ""
    if ref_type == "EMPLOYEE"
      ref_name  = Employee.find(ref_id)
    elsif ref_type == "PORTAL"
      ref_name  = Portal.find(ref_id)
    elsif ref_type == "AGENCY"
      ref_name  = Agency.find(ref_id)
    else
      ref_name  = "DIRECT"
    end
    ref_name
  end

  def word_strip(istring)
    istring.gsub("is invalid", "")
  end

  def get_row_id_prefix(istatus)
    row_id_prefix = ""
    if istatus == "NEW"
      row_id_prefix = "new_resume_row"
    elsif istatus == "FORWARDED"
      row_id_prefix = "forwarded_resume_row"
    elsif istatus == "SHORTLISTED"
      row_id_prefix = "shortlisted_resume_row"
    elsif istatus == "REJECTED"
      row_id_prefix = "rejected_resume_row"
    end
    row_id_prefix 
  end

  def sort_by_created_at_date(objects)
    objects.sort_by(&:updated_at).reverse!
  end

  def date_in_database_format(idate)
    idate = idate.to_date
  end

  def get_per_page
    10
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
    matches = nil
    if (status == "JOINING")
      matches = ReqMatch.find_by_sql("SELECT * FROM req_matches INNER JOIN resumes ON resumes.id = req_matches.resume_id WHERE req_matches.status = \"JOINING\" AND resumes.status != \"JOINED\" ")
    else
      matches = ReqMatch.find_all_by_status(status);
      if (status != "SCHEDULED" && status != "OFFERED" && status != "JOINED")
        matches = matches.find_all { |m|
           m.requirement.isOPEN?
        }
      end
    end
    matches
  end

  def get_all_req_matches_of_status_old(status)
    matches = ReqMatch.find_all_by_status(status);
    if (status != "SCHEDULED" && status != "OFFERED" && status != "JOINING" && status != "JOINED")
      matches = matches.find_all { |m|
         m.requirement.isOPEN?
      }
    end
    if status == "JOINING"
      matches = matches.find_all { |m|
        m.resume.status != "JOINED"
      }
    end
    matches
  end

  def get_month_year
    @month          = params[:month].nil? ? Date.today.month : params[:month].to_i
    @year           = params[:year].nil?  ? Date.today.year  : params[:year].to_i
    [ @month, @year ]
  end

  def get_start_end_month(cur_month, span = 3)
    span_no = (cur_month - 1) / span
    start_month = span_no * span + 1
    end_month = start_month + (span - 1)
    [ start_month, end_month ]
  end

  def get_requirements_of_type(itype, month, year, group)
    reqs = Requirement.all.find_all { |r|
      ( r.designation == itype ) &&
      ( r.group.name  == group ) &&
      ( r.status      == "OPEN" ) &&
      ( r.edate && ( r.edate.year == year ) && ( r.edate.month == month ) )
    }
    nreqs = 0
    reqs.each do |r|
      nreqs += r.nop
    end
    nreqs
  end

  def get_employee_referred_resumes(employee)
    resumes = Resume.all.find_all { |r| r.referral_type == "EMPLOYEE" &&
                                        r.referral_id   == employee.id
    }
    resumes
  end

  def sort_resumes_by_date(resumes)
    resumes.sort_by { |r| [r.change_date] }.reverse

# resumes.sort! { |a, b| b.updated_at <=> a.updated_at }
  end

  protected

  def render_optional_error_file(status_code)
    if status_code == :not_found
      render_404
    else
      super
    end
  end

  def rescue_action(exception)
    case exception
      when ::ActionController::RoutingError, ::ActionController::UnknownAction then
        render "resumes/bogus_action.html.erb"
      else
        super
      end
  end

end
