class AddPhoneIndexToResume < ActiveRecord::Migration
  def self.up
    add_index :resumes, [:phone]
  end

  def self.down
    remove_index :resumes, :column => :phone
  end
end
