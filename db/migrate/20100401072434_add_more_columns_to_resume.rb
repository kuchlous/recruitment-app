class AddMoreColumnsToResume < ActiveRecord::Migration[5.2]
  def self.up
    add_column :resumes, :referral_type, :string,  :null => false, :limit => 15
    add_column :resumes, :referral_id,   :integer, :null => false
  end

  def self.down
    remove_column :resumes, :referral_type
    remove_column :resumes, :referral_id
  end
end
