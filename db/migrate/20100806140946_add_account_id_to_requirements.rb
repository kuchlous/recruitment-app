class AddAccountIdToRequirements < ActiveRecord::Migration
  def self.up
    add_column :requirements, :account_id, :integer
  end

  def self.down
    remove_column :requirements, :account_id
  end
end
