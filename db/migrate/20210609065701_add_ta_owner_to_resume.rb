class AddTaOwnerToResume < ActiveRecord::Migration[5.2]
  def change
    add_column :resumes, :ta_owner_id, :integer
  end
end
