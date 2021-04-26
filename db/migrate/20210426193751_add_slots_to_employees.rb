class AddSlotsToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :n_interviews_per_week, :integer, :default => 0
  end
end
