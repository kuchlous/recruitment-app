class AddSdateEdateNopTypeToRequirements < ActiveRecord::Migration
  def self.up
    add_column :requirements, :sdate,    :date
    add_column :requirements, :edate,    :date
    add_column :requirements, :nop,      :integer,  :default => 1
    add_column :requirements, :req_type, :string,   :default => "ORDINARY"
  end

  def self.down
    remove_column :requirements, :sdate
    remove_column :requirements, :edate
    remove_column :requirements, :nop
    remove_column :requirements, :req_type
  end
end
