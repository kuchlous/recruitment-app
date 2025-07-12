class RenameSearchDataToResumeTextContent < ActiveRecord::Migration[5.2]
  def change
    rename_column :resumes, :search_data, :resume_text_content
  end
end 
