class InterviewSkill < ApplicationRecord
    has_and_belongs_to_many :interviewers,
                            :class_name => 'Employee',
                            :join_table => 'employees_interview_skills',
                            :foreign_key => 'interview_skill_id',
                            :association_foreign_key => 'employee_id'
    validates_presence_of   :name
    validates_uniqueness_of :name                        
end
