class AddColumnsToRequirements < ActiveRecord::Migration
  def self.up
    add_column :requirements, :status, :string, :default => "OPEN"
  end

  def self.down
    remove_column :requirements, :status
  end
end
