class AddLikelyToJoinInResumes < ActiveRecord::Migration
  def self.up
    add_column :resumes, :likely_to_join, :string, :limit => 1, :default => 'R'
  end

  def self.down
    remove_column :resumes, :likely_to_join
  end
end
