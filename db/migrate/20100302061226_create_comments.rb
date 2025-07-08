class CreateComments < ActiveRecord::Migration[5.2]
  def self.up
    create_table :comments do |t|

      t.text         :comment,     :default => nil
      t.integer      :resume_id,   :null => false
      t.integer      :employee_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
