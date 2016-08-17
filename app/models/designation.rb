class Designation < ActiveRecord::Base
  has_many :requirements
  validates_presence_of   :name
  validates_uniqueness_of :name
end
