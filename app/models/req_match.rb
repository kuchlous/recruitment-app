class ReqMatch < ActiveRecord::Base
  belongs_to :resume
  has_many   :interviews
  belongs_to :requirement
  belongs_to :forwarded_to,
             :class_name  => "Employee",
             :foreign_key => "forwarded_to"
  after_create :incr_resume_req_match_count
  after_save :update_resume

  def update_resume
    self.resume.update_overall_status
  end

  def ReqMatch.find_employee_requirements_req_matches(employee, open_reqs_only)
    req_match_array  = []

    # Find employee requirements
    employee_reqs    = employee.requirements
    
    if (open_reqs_only) 
      employee_reqs = employee_reqs.find_all { |r|
        ( r.status         == "OPEN" )
      }
    end

    # Find req matches corresponding to the employee requirements
    employee_reqs.each do |r|
      req_match_array += r.req_matches
    end

    req_match_array
  end

  def ReqMatch.find_scheduling_employee_req_matches(employee, open_reqs_only)
    req_match_array  = []

    # Find employee requirements
    employee_reqs    = employee.to_schedule_reqs
    
    if (open_reqs_only) 
      employee_reqs = employee_reqs.find_all { |r|
        ( r.status         == "OPEN" )
      }
    end

    # Find req matches corresponding to the employee requirements
    employee_reqs.each do |r|
      req_match_array += r.req_matches
    end

    req_match_array
  end

  def incr_resume_req_match_count
    logger.info("ReqMatch: In incr_resume_req_match_count")
    self.resume.nreq_matches += 1
    self.resume.save
  end

  # Finds if the employee have given the feedback or not for that resume.
  def is_feedback_given(employee)
    feedbacks           = self.resume.feedbacks
    feedbacks.each do |f|
      if employee == f.employee
        return true
      end
    end
    return false
  end

  def get_reqs_to_reqmatches
    req_array = []
    req       = self.requirement
    req_array.push([req.name, req.id])
    req_array
  end

  # we want to display the closest interview date to today giving
  # prioriy to dates in the future
  def get_display_interview_date
    closest_past_interview = nil
    closest_future_interview = nil
    interviews.each do |i|
      if i.interview_date
        if (i.interview_date >= Date.today)
          closest_future_interview ||= i.interview_date 
          if (i.interview_date < closest_future_interview)
            closest_future_interview = i.interview_date
          end
        else
          closest_past_interview ||= i.interview_date
          if (i.interview_date > closest_past_interview)
            closest_past_interview = i.interview_date
          end
        end
      end
    end

    if closest_future_interview 
      return closest_future_interview
    elsif closest_past_interview
      return closest_past_interview
    else
      return nil
    end

  end


end
