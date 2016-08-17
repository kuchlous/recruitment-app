class RemoveUniqidFromRequirements < ActiveRecord::Migration
  def self.up
    remove_column :requirements, :uniqid_id
  end

  def self.down
    add_column    :requirements, :uniqid_id, :integer
  end
end
