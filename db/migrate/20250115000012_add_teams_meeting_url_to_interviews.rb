class AddTeamsMeetingUrlToInterviews < ActiveRecord::Migration[5.2]
  def change
    add_column :interviews, :teams_meeting_url, :string
    add_index :interviews, :teams_meeting_url
  end
end
