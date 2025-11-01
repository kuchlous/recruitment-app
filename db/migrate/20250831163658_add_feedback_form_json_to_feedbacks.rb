class AddFeedbackFormJsonToFeedbacks < ActiveRecord::Migration[8.0]
  def change
    add_column :feedbacks, :feedback_form_json, :json
  end
end
