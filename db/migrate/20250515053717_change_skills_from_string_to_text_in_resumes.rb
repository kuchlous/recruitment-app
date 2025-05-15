class ChangeSkillsFromStringToTextInResumes < ActiveRecord::Migration[6.0]
  def change
    change_column :resumes, :skills, :text
  end
end
