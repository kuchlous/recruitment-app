class RequirementsController < ApplicationController

  before_action :check_for_login
  before_action :get_all_objects,                     :only => [ :new, :create, :edit, :update ]
  before_action :check_for_HR_or_ADMIN_or_REQMANAGER_or_BD, :only => [ :all_reqs ]

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
    status = "OPEN"
    status = "ANY" if params[:status] == "any"
    status = "HOLD" if params[:status] == "hold"

    @requirements = if status == "ANY"
                      get_current_employee.requirements
                    else
                      get_current_employee.requirements.where(status: status)
                    end
        
    if @requirements.size == 0
      flash[:warning] = "You do not have any requirements on your name."
    end
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
    @requirement.scheduling_employee_id = get_current_employee.id
    @requirement.exp = params[:req][:min_exp] + "-" + params[:req][:max_exp]
    
    if params[:eng_leads_names].present?
      eng_lead_names = params[:eng_leads_names].split(',').map(&:strip)
      eng_leads = Employee.where(name: eng_lead_names, employee_status: "ACTIVE")
      @requirement.eng_leads = eng_leads
    end
    
    if params[:ta_leads_names].present?
      ta_lead_names = params[:ta_leads_names].split(',').map(&:strip)
      ta_leads = Employee.where(name: ta_lead_names, employee_status: "ACTIVE")
      @requirement.ta_leads = ta_leads
    end
    
    respond_to do |format|
      if @requirement.save
        email_for_adding_requirement(@requirement)
        flash[:success] = "Created requirement: #{@requirement.name}"
        format.html { redirect_to :action => "index" }
      else
        log_errors(@requirement)
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

    old_owner = @requirement.employee
    exp          = params[:req][:min_exp] + "-" + params[:req][:max_exp]
    
    if params[:eng_leads_names].present?
      eng_lead_names = params[:eng_leads_names].split(',').map(&:strip)
      eng_leads = Employee.where(name: eng_lead_names, employee_status: "ACTIVE")
      @requirement.eng_leads = eng_leads
    else
      @requirement.eng_leads.clear
    end
    
    if params[:ta_leads_names].present?
      ta_lead_names = params[:ta_leads_names].split(',').map(&:strip)
      ta_leads = Employee.where(name: ta_lead_names, employee_status: "ACTIVE")
      @requirement.ta_leads = ta_leads
    else
      @requirement.ta_leads.clear
    end
    
    respond_to do |format|
      if @requirement.update(params.require(:requirement).permit!) && @requirement.update(:exp => exp)
        logger.info("Updated requirement")
        email_for_updating_requirement(@requirement)
        # Need to releoad object from database as update does not
        # seem to change fields of @requirement
        update_forwards(old_owner, Requirement.find(params[:id]))
        flash[:success] = "Updated requirement: #{@requirement.name}"
        format.html { redirect_to :action => "index" }
      else
        logger.info("Did not update requirement")
        log_errors(@requirement)
        format.html { render :action => "edit" }
      end
    end
  end

  def show
    @requirement   = Requirement.find(params[:id])
    @status        = params[:status]

    # Finding matches/forwards/interviews based upon the parameter coming from the url
    get_forwards_matches_to_reqs(@requirement) unless @status.nil?

    if is_HR? || is_BD? || is_ADMIN? || @requirement.employee.provides_visibility_to?(get_current_employee) || @requirement.eng_leads.include?(get_current_employee)
      # @accounts    = @requirement.accounts  # Removed accounts reference
      @forwarded   = @requirement.open_forwards
      @shortlisted = @requirement.shortlists
      @scheduled   = @requirement.scheduled
      @scheduled_l1 = @requirement.scheduled_l1
      @scheduled_l2 = @requirement.scheduled_l2
      @scheduled_l3 = @requirement.scheduled_l3
      @completed_l1 = @requirement.completed_l1
      @completed_l2 = @requirement.completed_l2
      @completed_l3 = @requirement.completed_l3
      @rejected    = @requirement.rejected
      @offered     = @requirement.offered
      @joining     = @requirement.joining
      @not_joined  = @requirement.not_joined
      @not_accepted = @requirement.not_accepted
      @hold        = @requirement.hold
      @hac         = @requirement.hac
      @yto         = @requirement.yto
      @eng_select  = @requirement.eng_select

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

    if @status       == "Forwarded"
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
    elsif @status    == "Scheduled-L1"
      @matches       = req.scheduled_l1
      @interviews_late, @interviews_done, @under_process = ResumesController.find_interviews_status(@matches)
      @render        = "interview_table"
      @is_req_match  = 1
    elsif @status    == "Scheduled-L2"
      @matches       = req.scheduled_l2
      @interviews_late, @interviews_done, @under_process = ResumesController.find_interviews_status(@matches)
      @render        = "interview_table"
      @is_req_match  = 1
    elsif @status    == "Scheduled-L3"
      @matches       = req.scheduled_l3
      @interviews_late, @interviews_done, @under_process = ResumesController.find_interviews_status(@matches)
      @render        = "interview_table"
      @is_req_match  = 1
    elsif @status    == "Completed-L1"
      @matches       = req.completed_l1
      @interviews_late, @interviews_done, @under_process = ResumesController.find_interviews_status(@matches)
      @render        = "interview_table"
      @is_req_match  = 1
    elsif @status    == "Completed-L2"
      @matches       = req.completed_l2
      @interviews_late, @interviews_done, @under_process = ResumesController.find_interviews_status(@matches)
      @render        = "interview_table"
      @is_req_match  = 1
    elsif @status    == "Completed-L3"
      @matches       = req.completed_l3
      @interviews_late, @interviews_done, @under_process = ResumesController.find_interviews_status(@matches)
      @render        = "interview_table"
      @is_req_match  = 1
    elsif @status    == "HAC"
      @matches       = req.hac
      @render        = "interview_table"
      @is_req_match  = 1
    elsif @status    == "Rejected"
      @forwards      = req.rejected
      @render        = "manager_index"
      @is_req_match  = 1
      @after_shortlist_page = true
    elsif @status    == "Hold"
      @matches       = req.hold
      @render        = "interview_table"
      @hold_on_req_page = 1
      @is_req_match  = 1
    elsif @status    == "Offered"
      @matches       = req.offered
      @render        = "joining_offered_hold_form"
      @offer_on_req_page = 1
      @is_req_match  = 1
    elsif @status    == "Yto"
      @matches       = req.yto
      @interviews_late, @interviews_done, @under_process = ResumesController.find_interviews_status(@matches)
      @render        = "interview_table"
      @is_req_match  = 1
    elsif @status    == "Joining"
      @matches       = req.joining
      @render        = "joining_offered_hold_form"
      @join_on_req_page  = 1
      @is_req_match  = 1
    elsif @status    == "Not Joined"
      @matches       = req.not_joined
      @render        = "manager_index"
      @is_req_match  = 1
    elsif @status    == "Not Accepted"
      @matches       = req.not_accepted
      @render        = "manager_index"
      @is_req_match  = 1
    elsif @status    == "Eng Select"
      @matches       = req.eng_select
      @render        = "manager_index"
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
    flash[:warning] = message
    redirect_back(fallback_location: root_path)
  end

  def close_requirement
    reqs_to_close = params[:req][:commands] - [""]
    req_closed_string = ""
    if reqs_to_close.length > 0
      reqs_to_close.each do |req_id|
        req = Requirement.find(req_id)
        if(req.update!(:status => "CLOSED EXPIRED"))
          req_closed_string += req.name+","
        end
      end
      flash[:success] = "Inactivated requirement: #{req_closed_string}"
    else
      flash[:warning] = "Please select checkbox to INACTIVE requirements."
    end
    redirect_back(fallback_location: root_path)
  end

  def autocomplete_requirements
    query = params[:query]
    requirements = Requirement.where(status: "OPEN")
                             .where("LOWER(name) LIKE LOWER(?)", "%#{query}%")
                             .limit(10)
                             .select(:id, :name)
    
    render json: requirements.map { |req| { id: req.id, name: req.name } }
  end

  def autocomplete_feedback_skills
    query = params[:query].to_s.strip

    skills = InterviewSkill.all
    if query.present?
      skills = skills.where("LOWER(name) LIKE LOWER(?)", "%#{query.downcase}%")
    end

    skills = skills.order(:name).limit(10).select(:id, :name)

    render json: skills.map { |skill| { id: skill.id, name: skill.name } }
  end

  def suggested_resumes_by_requirement
    @requirement = Requirement.find(params[:id])
    
    # Use requirement's embedding for search
    requirement_embedding = @requirement.get_embedding
    existing_resume_ids = @requirement.forwards.pluck(:resume_id) + @requirement.req_matches.pluck(:resume_id)
    
    Rails.logger.info "Using requirement embedding for requirement #{@requirement.id}"
    
    if requirement_embedding.present?
      # Find similar resumes using KNN search with exclusion
      @results = Resume.similar_resumes(
        requirement_embedding,
        where_conditions: { id: { not: existing_resume_ids } },
        page: params[:page],
        per_page: get_per_page
      )
    else
      @results = []
    end
    
    render 'resumes/_search_results_table', locals: { title: "Suggested Resumes (by Requirement) for #{@requirement.name}" }
  end

  def suggested_resumes_by_resumes
    @requirement = Requirement.find(params[:id])
    
    # Get resumes in priority order for average embedding calculation
    priority_resumes = get_priority_resumes_for_average(@requirement)
    
    # Determine which embedding to use for search
    search_embedding = if priority_resumes.size > 1
      # Calculate average embedding from priority resumes
      Rails.logger.info "Using average embedding from #{priority_resumes.size} priority resumes for requirement #{@requirement.id}"
      calculate_average_embedding(priority_resumes)
    else
      search_embedding = nil
    end
    
    existing_resume_ids = @requirement.forwards.pluck(:resume_id) + @requirement.req_matches.pluck(:resume_id)
    
    if search_embedding.present?
      # Find similar resumes using KNN search with exclusion
      @results = Resume.similar_resumes(
        search_embedding,
        where_conditions: { id: { not: existing_resume_ids } },
        page: params[:page],
        per_page: get_per_page
      )
    else
      @results = []
    end
    
    render 'resumes/_search_results_table', locals: { title: "Suggested Resumes (by Similar Resumes) for #{@requirement.name}" }
  end

private

  def get_priority_resumes_for_average(requirement)
    # Get resumes in priority order: joining, offered, yto, eng_select, scheduled, shortlisted
    # Limit to maximum 10 resumes
    priority_resumes = []
    
    # 1. Joining resumes
    joining_resumes = requirement.joining.includes(:resume).map(&:resume)
    priority_resumes.concat(joining_resumes)
    
    # 2. Offered resumes
    if priority_resumes.size < 10
      offered_resumes = requirement.offered.includes(:resume).map(&:resume)
      priority_resumes.concat(offered_resumes)
    end
    
    # 3. YTO resumes
    if priority_resumes.size < 10
      yto_resumes = requirement.yto.includes(:resume).map(&:resume)
      priority_resumes.concat(yto_resumes)
    end
    
    # 4. Eng Select resumes
    if priority_resumes.size < 10
      eng_select_resumes = requirement.eng_select.includes(:resume).map(&:resume)
      priority_resumes.concat(eng_select_resumes)
    end
    
    # 5. Scheduled resumes
    if priority_resumes.size < 10
      scheduled_resumes = requirement.scheduled.includes(:resume).map(&:resume)
      priority_resumes.concat(scheduled_resumes)
    end
    
    # 6. Shortlisted resumes
    if priority_resumes.size < 10
      shortlisted_resumes = requirement.shortlists.includes(:resume).map(&:resume)
      priority_resumes.concat(shortlisted_resumes)
    end
    
    # Limit to 10 resumes and remove duplicates
    priority_resumes.uniq.first(10)
  end

  def calculate_average_embedding(resumes)
    return nil if resumes.empty?
    
    # Get all valid embeddings from the resumes
    embeddings = resumes.map(&:get_embedding).compact
    
    Rails.logger.info "Found #{embeddings.length} valid embeddings out of #{resumes.length} shortlisted resumes"
    
    return nil if embeddings.empty?
    
    # Calculate the average of each dimension
    dimension_count = embeddings.first.length
    average_embedding = Array.new(dimension_count, 0.0)
    
    embeddings.each do |embedding|
      embedding.each_with_index do |value, index|
        average_embedding[index] += value
      end
    end
    
    # Divide by the number of embeddings to get the average
    average_embedding.map! { |sum| sum / embeddings.length }
    
    # Normalize the average embedding to unit length for cosine similarity
    magnitude = Math.sqrt(average_embedding.map { |x| x * x }.sum)
    if magnitude > 0
      average_embedding.map! { |x| x / magnitude }
    end
    
    Rails.logger.info "Calculated and normalized average embedding with #{dimension_count} dimensions"
    
    average_embedding
  end

  def email_for_adding_requirement(req)
    Emailer.requirement(get_current_employee, req).deliver_now
  end

  def email_for_updating_requirement(req)
    Emailer.requirement(get_current_employee, req, 0).deliver_now
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
        f = Forward.new(:emp_forwarded_to => new_owner,
                        :emp_forwarded_by => of.emp_forwarded_by,
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
    @ta_employees = @employees.find_all{|e| e.is_HR?}
    # @accounts     = get_all_accounts  # Removed accounts reference
  end

end
