class RemoveColumnFromInterviews < ActiveRecord::Migration
  def self.up
    remove_column :interviews, :resume_id
    remove_column :interviews, :requirement_id
  end

  def self.down
    add_column :interviews, :resume_id
    add_column :interviews, :requirement_id
  end
end
