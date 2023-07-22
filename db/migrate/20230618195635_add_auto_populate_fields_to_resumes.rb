# rails generate migration add_auto_populate_fields_to_resumes git_id:string linkedin_id:string skills:string
class AddAutoPopulateFieldsToResumes < ActiveRecord::Migration[5.2]
  def change
    add_column :resumes, :git_id, :string
    add_column :resumes, :linkedin_id, :string
    add_column :resumes, :skills, :string
  end
end
