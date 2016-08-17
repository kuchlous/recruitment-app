class AddMoreColumnsToRequirements < ActiveRecord::Migration
  def self.up
    add_column :requirements, :group_id, :integer
  end

  def self.down
    remove_column :requirements, :group_id
  end
end
