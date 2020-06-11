class RequirementsController < ApplicationController

  before_action :check_for_login
  before_action :get_all_objects,                     :only => [ :new, :create, :edit, :update ]
  before_action :check_for_HR_or_ADMIN_or_REQMANAGER_or_BD, :only => [ :all_reqs ]

  def index
    @requirements = Requirement.where(status: "OPEN").order("employee_id")

    respond_to do |format|
      format.html
    end
  end

  def all_reqs
    @requirements = Requirement.all.order("employee_id")
    render "index"
  end

  def search
    @requirements = Requirement.where(status:"OPEN").order("employee_id")
    search_text = params[:search]
    if search_text != ""
      employee = Employee.where("name = ? OR login = ?", search_text, search_text).first
      @requirements = @requirements.find_all { |req|
        req.employee == employee
      }
    end
    render "index"
  end

  def my_requirements
    @requirements        = get_current_employee.requirements.select { |req| req.status == "OPEN" }
    if @requirements.size == 0
      flash[:notice] = "You do not have any requirements on your name."
    end
    render "index"
  end 

  def new
    @requirement  = Requirement.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @requirement  = Requirement.new(params.require(:requirement).permit!)
    @requirement.posted_by = get_current_employee
    @requirement.accounts  = Account.find(params[:account_ids]) if params[:account_ids]
    @requirement.exp = params[:req][:min_exp] + "-" + params[:req][:max_exp]
    respond_to do |format|
      if @requirement.save
        email_for_adding_requirement(@requirement)
        flash[:notice] = "You have successfully created a requirement (#{@requirement.name})"
        format.html { redirect_to :action => "index" }
      else
        error_catching_and_flashing(@requirement)
        format.html { render :action => "new" }
      end
    end
  end

  def edit
    @requirement  = Requirement.find(params[:id])
  end

  def update
    logger.info("Trying to update requirement")
    @requirement  = Requirement.find(params[:id])
    # Destroying requirement accounts and then updating

    old_owner = @requirement.employee
    @requirement.accounts  = Account.find(params[:account_ids]) if params[:account_ids]
    exp          = params[:req][:min_exp] + "-" + params[:req][:max_exp]
    respond_to do |format|
      if @requirement.update_attributes(params.require(:requirement).permit!) && @requirement.update_attributes(:exp => exp)
        logger.info("Updated requirement")
        email_for_updating_requirement(@requirement)
        # Need to releoad object from database as update_attributes does not
        # seem to change fields of @requirement
        update_forwards(old_owner, Requirement.find(params[:id]))
        flash[:notice] = "You have successfully updated requirement (#{@requirement.name})"
        format.html { redirect_to :action => "index" }
      else
        logger.info("Did not update requirement")
        error_catching_and_flashing(@requirement)
        format.html { render :action => "edit" }
      end
    end
  end

  def show
    @requirement   = Requirement.find(params[:id])
    @status        = params[:status]

    # Finding matches/forwards/interviews based upon the parameter coming from the url
    get_forwards_matches_to_reqs(@requirement) unless @status.nil?

    if is_HR? || is_BD? || is_ADMIN? || @requirement.employee.provides_visibility_to?(get_current_employee)
      @accounts    = @requirement.accounts
      @req_forwards= @requirement.open_forwards
      @shortlists  = @requirement.shortlists
      @scheduled   = @requirement.scheduled
      @rejected    = @requirement.rejected
      @offered     = @requirement.offered
      @joining     = @requirement.joining
      @hold        = @requirement.hold

      respond_to do |format|
        format.html
      end
    else
      render "show_brief"
    end
  end

  def get_forwards_matches_to_reqs(req)
    @resumes           = []
    @forwards          = []
    @matches           = []
    @id_prefix         = "requirement_description_row"
    @counter_value     = ""
    @hold_on_req_page  = 0
    @offer_on_req_page = 0
    @join_on_req_page  = 0
    @after_shortlist_page = false

    if @status       == "Forwards"
      @forwards      = req.open_forwards
      @render        = "manager_index"
      @row_id_prefix = "req_forwards"
      @is_req_match  = 0
    elsif @status    == "Shortlisted"
      @forwards      = req.shortlists
      @render        = "manager_index"
      @row_id_prefix = "req_shortlists"
      @is_req_match  = 1
      @after_shortlist_page  = true
    elsif @status    == "Scheduled"
      @matches       = req.scheduled
      @interviews_late, @interviews_done, @under_process = ResumesController.find_interviews_status(@matches)
      @render        = "interview_table"
      @is_req_match  = 1
    elsif @status    == "Rejected"
      @forwards      = req.rejected
      @render        = "manager_index"
      @is_req_match  = 1
      @after_shortlist_page = true
    elsif @status    == "Hold"
      @matches       = req.hold
      @render        = "joining_offered_hold_form"
      @hold_on_req_page = 1
      @is_req_match  = 1
    elsif @status    == "Offered"
      @matches       = req.offered
      @render        = "joining_offered_hold_form"
      @offer_on_req_page = 1
      @is_req_match  = 1
    elsif @status    == "Joining"
      @matches       = req.joining
      @render        = "joining_offered_hold_form"
      @join_on_req_page  = 1
      @is_req_match  = 1
    end

    @forwards.each do |f| 
      @resumes.push(f.resume)
    end

    @resumes.uniq!
  end

  def req_analysis
    @month,  @year   = get_month_year
    @smonth, @emonth = get_start_end_month(@month)
    @partial         = params[:partial]
    if @partial
      @smonth        = params[:smonth].to_i
      @emonth        = params[:emonth].to_i
    end

    @req_analysis = {}
    Group.all.each do |group|
      @req_analysis[group] = get_analysis_data(@smonth, @emonth, @year, group.name)
    end
    render :partial => "requirements/req_analysis"#, :layout => !@partial
  end

  def get_analysis_data(start_month, end_month, year, group)
    all_months_analysis = {}
    Designation.all.each do |desg|
      all_months_analysis[desg]   ||= Array.new(end_month - start_month + 1)
      start_month.upto end_month do |month|
        all_months_analysis[desg] << get_requirements_of_type(desg, month, year, group)
      end
    end
    all_months_analysis
  end

  def destroy
    message = "Deleting an requirement will cause major percussions. So it is advisable
               not to delete requirement name. However, if you really want to delete it
               then please ask your administrator"
    logger.info(message)
    flash[:notice] = message
    redirect_to :back
  end

  def close_requirement
    reqs_to_close = params[:req][:commands] - [""]
    req_closed_string = ""
    if reqs_to_close.length > 0
      reqs_to_close.each do |req_id|
        req = Requirement.find(req_id)
        if(req.update_attributes!(:status => "CLOSED EXPIRED"))
          req_closed_string += req.name+","
        end
      end
      flash[:notice] = "You have successfully INACTIVATED requirement \'#{req_closed_string}\' "
    else
      flash[:notice] = "Please select checkbox to INACTIVE requirements."
    end
    redirect_to :back
  end

private
  def error_catching_and_flashing(object)
    unless object.valid?
      object.errors.each{ |mesg|
        logger.info(mesg)
      }
    end
  end

  def email_for_adding_requirement(req)
    Emailer.requirement(get_current_employee,
                                req)
  end

  def email_for_updating_requirement(req)
    Emailer.requirement(get_current_employee,
                                req,
                                0)
  end

  # This fn. is called when we change owner of a requirement. We need to change/
  # delete the forwards which had this requirement as one of requirements 
  # attached to them. Also we need to create corresponding forwards for the 
  # new owner.
  def update_forwards(old_owner, req)
    new_owner = req.employee

    if new_owner == old_owner
      return
    end

    old_forwards = old_owner.forwards.find_all { |f| 
      f.status == "FORWARDED" && f.requirements.include?(req)
    }

    # hash the forwards by resumes so we do not need to do a
    # a linear search later
    resume_to_forward_hash = {}
    new_owner.forwards.each do |f|
      resume_to_forward_hash[f.resume] = f
    end

    old_forwards.each do |of|
      r = of.resume 
      if resume_to_forward_hash[r]
        f = resume_to_forward_hash[r]
        f.requirements << req unless f.requirements.include?(req) 
      else
        f = Forward.new(:forwarded_to => new_owner,
                        :forwarded_by => of.forwarded_by,
                        :resume       => r,
                        :status       => "FORWARDED",
                        :requirements => [req])
      end
      f.save!
    end

    # Remove req from forward, and delete the forward completely
    # if it becomes empty
    old_forwards.each do |f|
      f.requirements.delete(req)
      if f.requirements.size == 0
        f.destroy
      end
    end
  end

  def get_all_objects
    @groups       = get_all_groups
    @designations = get_all_designations
    @employees    = get_all_employees
    @accounts     = get_all_accounts
  end
end
