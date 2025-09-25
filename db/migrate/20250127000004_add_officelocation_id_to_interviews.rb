class AddOfficelocationIdToInterviews < ActiveRecord::Migration[5.2]
  def change
    add_column :interviews, :officelocation_id, :bigint
    add_index :interviews, :officelocation_id
    add_foreign_key :interviews, :officelocations
  end
end
