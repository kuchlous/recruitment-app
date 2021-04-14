class EmployeesInterviewSkills < ActiveRecord::Migration[5.2]
  def change
    create_table :employees_interview_skills, id: false do |t|
      t.belongs_to :employee
      t.belongs_to :interview_skill
    end
  end
end
