class AddAiSummaryToResumes < ActiveRecord::Migration[8.0]
  def change
    add_column :resumes, :ai_summary, :text
  end
end
