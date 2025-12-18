class AddSkillsBasedToInterviews < ActiveRecord::Migration[8.0]
  def change
    add_column :interviews, :skills_based, :boolean, default: false, null: false
  end
end
