class Feedback < ActiveRecord::Base
  belongs_to            :employee
  belongs_to            :resume

  validates_presence_of :resume_id
  validates_presence_of :employee_id
  validates_presence_of :rating

  def numerical_rating
    if rating == "Very Good"
      return 5.0
    elsif rating == "Good"
      return 4.0
    elsif rating == "Average"
      return 3.0
    elsif rating == "Below Average"
      return 2.0
    elsif rating == "Poor"
      return 1.0
    end
  end
end
