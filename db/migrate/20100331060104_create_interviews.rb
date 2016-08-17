class CreateInterviews < ActiveRecord::Migration
  def self.up
    create_table :interviews do |t|

      t.integer            :resume_id,      :null => false
      t.integer            :requirement_id, :null => false
      t.integer            :employee_id,    :null => false
      t.date               :interview_date, :null => false
      t.time               :interview_time, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :interviews
  end
end
