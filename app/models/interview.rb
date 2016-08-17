class Interview < ActiveRecord::Base

  belongs_to :requirement
  belongs_to :req_match
  belongs_to :employee

  validates_presence_of :employee_id
  validates_presence_of :interview_date

  validate_on_create :overlapping_interviews
  validate :date_should_not_be_less_than_current_date

  def overlapping_interviews
    if self.employee
      interviews = self.employee.interviews
      for interview in interviews
        if ( interview.interview_date == self.interview_date ) && ( interview.interview_time == self.interview_time )
          msg = "There is already an interview request for #{self.employee.name.titleize} with this date/time"
          errors.add(msg)
        end
      end
    end
  end

  def date_should_not_be_less_than_current_date
    if self.interview_date
      if self.interview_date < Date.today
        errors.add('Interview date can not be earlier than today')
      end
    end
  end
end
