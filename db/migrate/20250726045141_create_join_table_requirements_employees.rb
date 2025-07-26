class CreateJoinTableRequirementsEmployees < ActiveRecord::Migration[6.0]
  def change
    create_join_table :requirements, :employees do |t|
      t.index [:requirement_id, :employee_id]
      t.index [:employee_id, :requirement_id]
    end
  end
end
