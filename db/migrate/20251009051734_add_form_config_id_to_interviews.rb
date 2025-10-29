class AddFormConfigIdToInterviews < ActiveRecord::Migration[8.0]
  def change
    add_column :interviews, :form_config_id, :integer
  end
end
