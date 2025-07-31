class AddInterviewIdToFeedbacks < ActiveRecord::Migration[5.2]
  def change
    add_column :feedbacks, :interview_id, :integer
    add_index :feedbacks, :interview_id
    add_foreign_key :feedbacks, :interviews
  end
end 
