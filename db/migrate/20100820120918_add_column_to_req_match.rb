class AddColumnToReqMatch < ActiveRecord::Migration
  def self.up
    add_column :req_matches, :interview_status, :string, :default => ""
  end

  def self.down
    remove_column :req_matches, :interview_status
  end
end
