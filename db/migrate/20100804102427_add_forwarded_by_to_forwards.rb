class AddForwardedByToForwards < ActiveRecord::Migration[5.2]
  def self.up
    add_column    :forwards, :forwarded_by, :integer
  end

  def self.down
    remove_column :forwards, :forwarded_by
  end
end
