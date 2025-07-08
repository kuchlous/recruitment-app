class AddColumnsToRequirements < ActiveRecord::Migration[5.2]
  def self.up
    add_column :requirements, :status, :string, :default => "OPEN"
  end

  def self.down
    remove_column :requirements, :status
  end
end
