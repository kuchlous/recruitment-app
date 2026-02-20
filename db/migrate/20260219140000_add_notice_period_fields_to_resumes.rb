class AddNoticePeriodFieldsToResumes < ActiveRecord::Migration[8.0]
  def change
    add_column :resumes, :serving_notice_period, :boolean, default: false, null: false
    add_column :resumes, :last_working_day, :date
    add_column :resumes, :notice_reason, :text
  end
end
