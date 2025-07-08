class AddPhoneIndexToResume < ActiveRecord::Migration[5.2]
  def self.up
    add_index :resumes, [:phone]
  end

  def self.down
    remove_index :resumes, :column => :phone
  end
end
