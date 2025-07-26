class AddStatusToInterviews < ActiveRecord::Migration[6.0]
  def change
    add_column :interviews, :status, :string
  end
end
