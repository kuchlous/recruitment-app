class AddIndicesToResume < ActiveRecord::Migration
  def self.up
    add_index :resumes, [:overall_status], :unique => false
    add_index :resumes, [:referral_id], :unique => false
    add_index :resumes, [:referral_type], :unique => false
  end

  def self.down
    remove_index :resumes, :column => :overall_status
    remove_index :resumes, :column => :referral_id
    remove_index :resumes, :column => :referral_type
  end
end
