class AddDesignationIdToRequirements < ActiveRecord::Migration
  def self.up
    add_column :requirements, :designation_id, :integer
  end

  def self.down
    remove_column :requirements, :designation_iddesignation_id
  end
end
