class Comment < ActiveRecord::Base
  belongs_to :employee
  belongs_to :resume,
             :class_name  => "Resume",
             :foreign_key => "resume_id"
end
