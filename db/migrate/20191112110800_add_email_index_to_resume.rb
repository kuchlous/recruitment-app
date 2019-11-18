class AddEmailIndexToResume < ActiveRecord::Migration
  def self.up
    add_index :resumes, [:email]
  end

  def self.down
    remove_index :resumes, :column => :email
  end
end
