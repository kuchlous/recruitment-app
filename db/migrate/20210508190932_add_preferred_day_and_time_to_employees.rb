class AddPreferredDayAndTimeToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :preferred_day_and_time, :text
  end
end
