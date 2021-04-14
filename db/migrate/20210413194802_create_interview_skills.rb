class CreateInterviewSkills < ActiveRecord::Migration[5.2]
  def change
    create_table :interview_skills do |t|
      t.string :name

      t.timestamps
    end
  end
end
