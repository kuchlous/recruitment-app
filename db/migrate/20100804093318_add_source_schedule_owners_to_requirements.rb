class AddSourceScheduleOwnersToRequirements < ActiveRecord::Migration
  def self.up
    add_column :requirements, :source_owner,    :integer
    add_column :requirements, :schedule_owner,  :integer
  end

  def self.down
    remove_column :requirements, :source_owner
    remove_column :requirements, :schedule_owner
  end
end
