class AddColumnsToInterviews < ActiveRecord::Migration
  def self.up
    add_column :interviews, :status, :string, :limit => 10, :default => 'NEW'
  end

  def self.down
    remove_column :interviews, :status
  end
end
