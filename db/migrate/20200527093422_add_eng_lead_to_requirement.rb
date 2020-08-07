class AddEngLeadToRequirement < ActiveRecord::Migration
  def self.up
    add_column :requirements, :eng_lead_id, :integer
  end

  def self.down
    remove_column :requirements, :eng_lead_id
  end
end
