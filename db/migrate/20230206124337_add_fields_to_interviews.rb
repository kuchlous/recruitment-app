# rails generate migration add_fields_to_interviews interview_level:integer 
# rails db:migrate
class AddFieldsToInterviews < ActiveRecord::Migration[5.2]
  def change
    add_column :interviews, :interview_level, :integer
  end
end
