class AddMoreMoreColumnToResumes < ActiveRecord::Migration
  def self.up
    add_column :resumes, :email, :string
    add_column :resumes, :phone, :string
    add_column :resumes, :joining_date, :date
  end

  def self.down
    remove_column :resumes, :email
    remove_column :resumes, :phone
    remove_column :resumes, :joining_date
  end
end
