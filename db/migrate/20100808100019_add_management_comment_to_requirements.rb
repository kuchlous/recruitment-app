class AddManagementCommentToRequirements < ActiveRecord::Migration[5.2]
  def self.up
    add_column :requirements, :mgt_comment, :text
  end

  def self.down
    remove_column :requirements, :mgt_comment
  end
end
