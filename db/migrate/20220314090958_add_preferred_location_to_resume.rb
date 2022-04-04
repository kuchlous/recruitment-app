class AddPreferredLocationToResume < ActiveRecord::Migration[5.2]
  def change
    add_column :resumes, :preferred_location, :string
  end
end
