class AddForwardAndReqMatchCountToResume < ActiveRecord::Migration
  def self.up
    add_column :resumes, :nreq_matches, :integer, :default => 0
    add_column :resumes, :nforwards, :integer, :default => 0
  end

  def self.down
    remove_column :resumes, :nforwards
    remove_column :resumes, :nreq_matches
  end
end
