class AddLastForwardToRequirements < ActiveRecord::Migration[5.2]
  def change
    add_column :requirements, :last_forward_recieved, :date
  end
end
