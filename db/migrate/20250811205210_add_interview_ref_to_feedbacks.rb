class AddInterviewRefToFeedbacks < ActiveRecord::Migration[8.0]
  def change
    add_reference :feedbacks, :interview, index: true, foreign_key: true
  end
end
