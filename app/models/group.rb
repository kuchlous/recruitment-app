class Group < ActiveRecord::Base
  has_many                :requirements
  belongs_to              :employee

  validates_presence_of   :name
  validates_presence_of   :employee_id
  validates_uniqueness_of :name
end
