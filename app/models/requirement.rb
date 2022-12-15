class Requirement < ActiveRecord::Base
  belongs_to              :employee
  belongs_to              :designation
  has_many                :interviews
  has_many                :req_matches
  has_and_belongs_to_many :forwards
  has_and_belongs_to_many :accounts
  belongs_to              :group,
                          :class_name  => "Group",
                          :foreign_key => "group_id"
  belongs_to              :posted_by,
                          :class_name  => "Employee",
                          :foreign_key => "posting_emp_id"

  belongs_to              :scheduling_emp,
                          :optional => true,
                          :class_name => "Employee",
                          :foreign_key => "scheduling_employee_id"
  belongs_to              :ta_lead,
                          :optional => true,
                          :class_name => "Employee",
                          :foreign_key => "ta_lead_id"
  belongs_to              :eng_lead,
                          :optional => true,
                          :class_name => "Employee",
                          :foreign_key => "eng_lead_id"

  # Presence stuff
  validates_presence_of :name
  validates_presence_of :employee_id
  validates_presence_of :designation_id
  validates_presence_of :group_id

  # Uniqueness stuff
  validates_uniqueness_of :name

  def Requirement.get_experience_array
    exp_array = []
    for i in 1..20
      exp_array << i
    end

    exp_array
  end

  def Requirement.get_requirement_array_for_select
    req_array = []
    all_ordered_requirements = Requirement.all.order(:name)
    all_open_requirements = all_ordered_requirements.find_all {
      |req| req.status == "OPEN"
    }
    all_open_requirements.each do |req|
      req_array.push([req.name, req.id])
    end
    req_array
  end

  def Requirement.get_all_requirement_array_for_select
    req_array = []
    req_array.push(["Select Req", 0])
    all_ordered_requirements = Requirement.all.order(:name)
    all_ordered_requirements.each do |req|
      req_array.push([req.name, req.id])
    end
    req_array
  end

  def Requirement.get_employee_requirement_array(employee)
    emp_req_array = []
    employee.requirements.each do |req|
      emp_req_array.push([req.name, req.id])
    end
    emp_req_array
  end

  def open_forwards
    self.forwards.find_all { |f|
      f.status == "FORWARDED"
    }
  end

  def shortlists
    self.req_matches.find_all { |r|
      r.status == "SHORTLISTED"
    }
  end

  def scheduled
    self.req_matches.find_all { |r|
      r.status == "SCHEDULED" &&
      r.resume.resume_overall_status != "Future"
    }
  end

  def rejected
    # Find forward's rejected also
    self.req_matches.find_all { |r|
      r.status == "REJECTED"
    }
  end

  def yto
    self.req_matches.where(status: "YTO")
  end

  def hold
    self.req_matches.find_all { |r|
      r.status == "HOLD"
    }
  end

  def offered
    self.req_matches.find_all { |r|
      r.status == "OFFERED"
    }
  end

  def joining
    self.req_matches.find_all { |r|
      r.status        == "JOINING" &&
      r.resume.resume_overall_status == "Joining Date Given"
    }
  end

  def Requirement.open_requirements
    Requirement.all.find_all { |r|
      r.status == "OPEN"
    }
  end

  def isOPEN?
    if self.status == "OPEN"
      return true
    else
      return false
    end
  end

  def name_for_js
    if name
      return name.gsub(/'|"/, '')
    else
      return name
    end
  end

end
