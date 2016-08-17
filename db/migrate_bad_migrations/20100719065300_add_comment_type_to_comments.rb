class AddCommentTypeToComments < ActiveRecord::Migration
  def self.up
    add_column    :comments, :ctype, :string, :limit => 10, :default => "USER"
  end

  def self.down
    remove_column :comments, :ctype
  end
end
