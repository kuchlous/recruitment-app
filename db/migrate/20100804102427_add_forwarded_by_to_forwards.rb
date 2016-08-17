class AddForwardedByToForwards < ActiveRecord::Migration
  def self.up
    add_column    :forwards, :forwarded_by, :integer
  end

  def self.down
    remove_column :forwards, :forwarded_by
  end
end
