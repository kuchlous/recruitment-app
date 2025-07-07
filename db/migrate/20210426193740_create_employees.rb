class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.string   :name
      t.integer  :eid
      t.string   :login
      t.string   :email
      t.integer  :manager_id
      t.string   :employee_type
      t.string   :employee_status, :default => "ACTIVE"
      t.integer  :account_id
      t.boolean  :is_admin,        :default => false
      t.date     :joining_date
      t.date     :leaving_date
      t.integer  :group_id

      t.timestamps null: false
    end
  end
end
