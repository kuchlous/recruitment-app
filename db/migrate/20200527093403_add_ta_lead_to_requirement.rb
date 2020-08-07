class AddTaLeadToRequirement < ActiveRecord::Migration
  def self.up
    add_column :requirements, :ta_lead_id, :integer
  end

  def self.down
    remove_column :requirements, :ta_lead_id
  end
end
