class ChangeInterviewsTimeAndDateToNull < ActiveRecord::Migration[5.2]
  def self.up
    change_column :interviews, :interview_date, :date, :null => true
    change_column :interviews, :interview_time, :time, :null => true
  end

  def self.down
  end
end
