class AddDurationToInterviews < ActiveRecord::Migration[5.2]
  def change
    add_column :interviews, :duration, :integer, default: 60, null: false, comment: "Duration in minutes"
  end
end
