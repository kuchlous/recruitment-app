class AddStatusIndexToResumes < ActiveRecord::Migration[5.2]
  def self.up
    add_index :resumes, [:status], :unique => false
  end

  def self.down
    remove_index :resumes, :column => :status
  end
end
