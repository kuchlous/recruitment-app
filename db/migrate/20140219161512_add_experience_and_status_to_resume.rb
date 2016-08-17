class AddExperienceAndStatusToResume < ActiveRecord::Migration
  def self.up
    add_column :resumes, :exp_in_months, :integer
    add_column :resumes, :overall_status, :string
  end

  def self.down
    remove_column :resumes, :exp_in_months
    remove_column :resumes, :overall_status
  end
end
