class AddColumnToInterviews < ActiveRecord::Migration[5.2]
  def self.up
    add_column :interviews, :req_match_id, :integer, :null => false
  end

  def self.down
    remove_column :interviews, :req_match_id
  end
end
