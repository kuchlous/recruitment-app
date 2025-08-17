class Requirement < ActiveRecord::Base
  belongs_to              :employee
  belongs_to              :designation
  has_many                :interviews
  has_many                :req_matches
  has_and_belongs_to_many :forwards
  has_and_belongs_to_many :eng_leads, class_name: "Employee", join_table: "employees_requirements"
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

  # Presence stuff
  validates_presence_of :name
  validates_presence_of :employee_id
  validates_presence_of :designation_id
  validates_presence_of :group_id

  # Uniqueness stuff
  validates_uniqueness_of :name, :case_sensitive => false

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
    self.forwards.where(status: "FORWARDED")
  end

  def shortlists
    self.req_matches.where(status: "SHORTLISTED")
  end

  def scheduled
    self.req_matches.joins(:resume).where(status: "SCHEDULED").where.not(resumes: {overall_status: "Future"})
  end

  def rejected
    self.req_matches.where(status: "REJECTED")
  end

  def yto
    self.req_matches.where(status: "YTO")
  end

  def hold
    self.req_matches.where(status: "HOLD")
  end

  def offered
    self.req_matches.where(status: "OFFERED")
  end

  def joining
    self.req_matches.joins(:resume).where(status: "JOINING").where(resumes: {overall_status: "Joining Date Given"})
  end

  def Requirement.open_requirements
    Requirement.all.where(status: "OPEN")
  end

  def isOPEN?
    self.status == "OPEN"
  end

  def name_for_js
    if name
      return name.gsub(/'|"/, '')
    else
      return name
    end
  end

  # Class methods for getting status and type options
  def self.status_options_for_select
    [
      ["Open", "OPEN"],
      ["Hold", "HOLD"],
      ["Closed - Lost", "CLOSED LOST"],
      ["Closed - Won", "CLOSED WON"],
      ["Closed - Cancelled", "CLOSED CANCELLED"],
      ["Closed - Expired", "CLOSED EXPIRED"],
      ["Closed - Offered", "CLOSED OFFERED"],
      ["Closed - Joining", "CLOSED JOINING"],
      ["Closed - Delete", "CLOSED DELETE"]
    ]
  end

  def self.req_type_options_for_select
    [
      ["Ordinary", "ORDINARY"],
      ["Hot", "HOT"]
    ]
  end

end
