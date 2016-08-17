class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|

      t.integer          :resume_id,   :null => false
      t.integer          :employee_id, :null => false
      t.string           :rating,      :null => false, :limit => 20
      t.text             :feedback

      t.timestamps
    end
  end

  def self.down
    drop_table :feedbacks
  end
end
