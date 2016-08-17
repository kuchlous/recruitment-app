class AddColumnsToResumes < ActiveRecord::Migration
  def self.up
    add_column :resumes, :employee_id,  :integer, :null => false
    add_column :resumes, :summary,      :text,    :null => false
    add_column :resumes, :search_data,  :text
    add_column :resumes, :uniqid_id,    :integer
  end

  def self.down
    remove_column :resumes, :employee_id
    resume_column :resumes, :summary
    resume_column :resumes, :search_data
    remove_column :resumes, :uniqid_id
  end
end
