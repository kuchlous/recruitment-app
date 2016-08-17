class CreateRequirements < ActiveRecord::Migration
  def self.up
    create_table :requirements do |t|

      t.string             :name,           :null => false
      t.integer            :posting_emp_id
      t.integer            :employee_id
      t.integer            :uniqid_id      
      t.text               :skill
      t.text               :description
      t.string             :exp
      t.timestamps
    end
  end

  def self.down
    drop_table :requirements
  end
end
