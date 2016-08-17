class AddStatusToResume < ActiveRecord::Migration
  def self.up
    add_column :resumes, :status, :string, :limit => 10, :default => ""
  end

  def self.down
    remove_column :resumes, :status
  end
end
