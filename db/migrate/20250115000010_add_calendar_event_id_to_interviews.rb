class AddCalendarEventIdToInterviews < ActiveRecord::Migration[5.2]
  def change
    add_column :interviews, :calendar_event_id, :string
    add_index :interviews, :calendar_event_id
  end
end
