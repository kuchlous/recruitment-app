class AddColumnsToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :resume_id, :integer, :null => false
  end

  def self.down
    remove_column :comments, :resume_id
  end
end
