class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :req_comments do |t|

      t.text         :comment,     :default => nil
      t.integer      :resume_id,   :null => false
      t.integer      :employee_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :req_comments
  end
end
