class EmployeesController < ApplicationController
  before_filter :check_for_login, :except => [ "login" ]

  def index
    @employees = Employee.find_all_by_employee_status("ACTIVE", :order => :name)

    if params[:page]
      character_name = params[:character_name]
      @employees     = Employee.find(:all, :conditions => ["name like ?", character_name + "%"], :order => :eid)
    end
  end

  def list_my_employees
    @employees = Employee.find_all_by_employee_status("ACTIVE", :order => :name).find_all { 
                        |e| e.provides_visibility_to?(get_current_employee) 
    }

    if params[:page]
      character_name = params[:character_name]
      @employees     = Employee.find(:all, :conditions => ["name like ?", character_name + "%"], :order => :eid)
      @employees     = @employees.find_all {
                        |e| e.provides_visibility_to?(get_current_employee) && e.employee_status == "ACTIVE"
      }
    end
    render "index"
  end

  def is_outside_ip(ip)
    false
    # !/192.168.*/.match(ip)
  end

  def login
    if request.post?
      if RAILS_ENV == "production"
# employee = Net::IMAP.new('apps.mirafra.com')
        # employee = Net::IMAP.new('192.168.1.2')
        employee = Net::IMAP.new('182.75.92.100', 993, true, nil, false)
        employee.login(params[:login], params[:password])
      else
        employee = Employee.find_by_login(params[:login].to_s)
      end
      if employee
        if RAILS_ENV == "production"
          employee.logout()
        end
        employee = Employee.find_by_login(params[:login].to_s)
        if (!employee)
          flash[:notice] = "Your name is not in the recruitment system.
                            Please contact your manager to add your name to the system"
          redirect_to :controller => "home", :action => "index"
        else
          if employee.employee_status == "ACTIVE"
            remote_ip = request.remote_ip
            if (is_outside_ip(remote_ip) && !employee.can_access_remote?) 
              logger.info("#{employee.name} tried to access remotely.")
              flash[:notice] = "You can not login to recruitment account remotely."
              redirect_to :controller => "home", :action => "index"
            else
              logger.info("Succesfully logged in #{employee.id}")
              set_logged_employee(employee.id)
              set_current_employee(employee.id)
              redirect_back_or_default(:controller => "home", :action => "actions_page")
            end
          else
            logger.info("#{employee.name} is inactivated.")
            flash[:notice] = "You can not login to your recruitment account because
                              your account has been set to inactivated.
                              Please contact your manager"

            redirect_to :controller => "home", :action => "index"
          end
        end
      else
        flash[:notice] = "Your name is not in the recruitment system.
                          Please contact your manager to add your name to the system"
        redirect_to :controller => "home", :action => "index"
      end
    end

    rescue Net::IMAP::NoResponseError => e
      logger.info("Please provide mirafra mail username and password.");
      flash[:notice] = "Please provide mirafra mail username and password."
      redirect_to :controller => "home", :action => "index"

  end

  def logout
    set_current_employee(nil)
    set_logged_employee(nil)
    session[:return_to] = nil
    redirect_to :controller => "home", :action => "index"
  end


  def change_to
    unless params[:id].nil?
      employee = Employee.find_by_id(params[:id])
      if (employee && employee.provides_visibility_to?(get_logged_employee))
        set_current_employee(employee.id)
      else
        flash[:notice] = "You can not work on behalf of this employee."
      end
    end
    redirect_to :controller => "home", :action => "actions_page"
  end

end
