class AddManualStatusToResumes < ActiveRecord::Migration[5.2]
  def self.up
    add_column :resumes, :manual_status, :string
  end

  def self.down
    remove_column :resumes, :manual_status
  end
end
