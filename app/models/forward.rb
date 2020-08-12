class Forward < ActiveRecord::Base
  belongs_to :forwarded_to,
             :class_name  => "Employee",
             :foreign_key => "forwarded_to"
  belongs_to :forwarded_by,
             :class_name  => "Employee",
             :foreign_key => "forwarded_by"
  belongs_to :resume
  has_and_belongs_to_many :requirements
  after_create :incr_resume_req_match_count
  after_save :update_resume

  def update_resume
    if self.status_changed?
      self.resume.update_overall_status
    end
  end

  def incr_resume_req_match_count
    self.resume.nforwards += 1
    self.resume.save
  end

  def get_reqs_to_forward
    req_array = []
    all_requirements = self.requirements.all.order(:name)
    all_open_requirements = all_requirements.find_all {
      |r| r.status == "OPEN"
    }
    all_open_requirements.each do |r|
      req_array.push([r.name, r.id])
    end
    if req_array.nil? || req_array.empty?
      req_array = self.forwarded_to.get_reqs_to_forward
    end
    req_array
  end
end
