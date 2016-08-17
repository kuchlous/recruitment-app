class AddSchedulingEmployeeToRequirement < ActiveRecord::Migration
  def self.up
    add_column :requirements, :scheduling_employee_id, :integer
  end

  def self.down
    remove_column :requirements, :scheduling_employee_id
  end
end
