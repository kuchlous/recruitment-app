class Employee < ActiveRecord::Base
  has_many    :sessions
  has_many    :comments
  has_many    :interviews
  has_many    :feedbacks
  has_and_belongs_to_many   :interview_skills
  has_many    :requirements,
              :class_name  => "Requirement",
              :foreign_key => "employee_id"
  has_many    :to_schedule_reqs,
              :class_name => "Requirement",
              :foreign_key => "scheduling_employee_id"
  has_many    :forwards,
              :class_name  => "Forward",
              :foreign_key => "forwarded_to"
  has_many    :req_matches,
              :class_name  => "ReqMatch",
              :foreign_key => "forwarded_to"
  has_many    :resumes,
              :class_name  => "Resume",
              :foreign_key => "employee_id"
  has_many    :in_messages,
              :class_name  => "Message",
              :foreign_key => "id"
  has_many    :out_messages,
              :class_name  => "Message",
              :foreign_key => "id"
  belongs_to  :group,
              :class_name  => "Group",
              :foreign_key => "group_id"
  belongs_to  :manager,
              :class_name => "Employee",
              :foreign_key => "manager_id"

  def Employee.get_manager_array_for_select
    manager_array = []
    all_managers = Employee.all.find_all { |e| 
      e.is_manager? &&
      e.employee_status == "ACTIVE" 
    }
    all_managers.each do |manager|
      manager_array.push([manager.login, manager.id])
    end
    manager_array
  end

  def Employee.get_employee_array_for_select
    emp_array = []
    all_emps = Employee.where(:employee_status => "ACTIVE" ).order(:name)
    all_emps.each do |emp|
      emp_array.push([emp.name, emp.id])
    end
    emp_array
  end

  def is_HR?
    if /HR/.match(employee_type) || /BUSDEV/.match(employee_type)
      return self
    else
      return false
    end
  end

  def is_ADMIN?
    if self.is_admin
      return self
    else
      return false
    end
  end

  def is_manager?
    /MANAGER/.match(employee_type)
  end

  def is_MANAGER?
    /MANAGER/.match(employee_type)
  end

  def is_PM?
    /PM/.match(employee_type)
  end

  def is_GM?
    /GM/.match(employee_type)
  end

  def is_BD?
    /BD/.match(employee_type)
  end

  def is_TA_HEAD?
    /TA_HEAD/.match(employee_type)
  end

  def is_GROUP_HEAD?
    /GROUP_HEAD/.match(employee_type)
  end

  def is_RMS_ANALYST?
    /RMS_ANALYST/.match(employee_type)
  end

  @@remote_access_disallowed = ["sruthinambiar@mirafra.com",
                                "sivajyothi@mirafra.com",
                                "sachinmirashe@mirafra.com",
                                "saisushrutha@mirafra.com",
                                "gpraveena@mirafra.com",
                                "ridhima@mirafra.com",
                                "prathiba@mirafra.com",
                                "jagadeesh@mirafra.com",
                                "ajittiwari@mirafra.com",
                                "harshithahp@mirafra.com",
                                "shilpaks@mirafra.com",
                                "santoshbaradi@mirafra.com",
                                "shivapavan@mirafra.com",
                                "uzmafaheen@mirafra.com",
                                "sunilshilpi@mirafra.com",
                                "sonals@mirafra.com", 
                                "hepzybha@mirafra.com", 
                                "dhanashree@mirafra.com", 
                                "sandeepkammula@mirafra.com", 
                                "ipsitadas@mirafra.com", 
                                "satvinder@mirafra.com", 
                                "priyankasharma@mirafra.com",
                                "venulaxmi@mirafra.com",
                                "shailesh@mirafra.com",
                                "balbirk@mirafra.com", 
                                "srikanthreddy@mirafra.com",
                                "manohar@mirafra.com", 
                                "gopinath@mirafra.com",
                                "srinivaskr@mirafra.com",
                                "chakradhar@mirafra.com"]
  def can_access_remote?
    return !@@remote_access_disallowed.include?(self.email)
  end

  def is_REQ_MANAGER?
    self.requirements.where(status: "OPEN").count > 0
  end

  def provides_visibility_to?(other)
    if other.is_admin == true
      return true
    end

    if other == self
      return true
    end

    # CEO/COO only visible to admin
    if (self.manager == self)
      return false
    end

    # CEO/COO
    if (other.manager == other)
      return true
    end

    emp = self
    while (emp.manager)
      # Reached CEO/COO, already handled this case
      if (emp == emp.manager)
        return false
      end
      # other is in the chain of managers
      if (emp.manager == other)
        return true
      end
      emp = emp.manager
    end

    return false
  end

  def get_reqs_to_forward
    req_array = []
    all_requirements = self.requirements.all.order(:name)
    all_open_requirements = all_requirements.find_all {
      |req| req.status == "OPEN"
    }
    all_open_requirements.each do |req|
      req_array.push([req.name, req.id])
    end
    req_array
  end

  def gm
    manager = self
    while (true)
      return manager if manager.is_GM?
      return manager if manager == manager.manager
      return nil if !manager.manager
      manager = manager.manager
    end
  end

  def ta_head
    manager = self
    while (true)
      return manager if manager.is_TA_HEAD?
      return nil if manager == manager.manager
      return nil if !manager.manager
      manager = manager.manager
    end
  end

  def current_email
    employee = self
    while (employee.employee_status != "ACTIVE" && !employee.is_GM?)
      employee = employee.manager
    end
    employee.email
  end

  def Employee.get_finance_employee
    Employee.find_by_email("sobhan@mirafra.com")
  end

  def Employee.get_sysadmin_employee
    Employee.find_by_email("somu@mirafra.com")
  end

  def Employee.get_HR_employee
    Employee.find_by_email("shailesh@mirafra.com")
  end

end
