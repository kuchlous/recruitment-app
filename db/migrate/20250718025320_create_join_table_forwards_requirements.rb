class CreateJoinTableForwardsRequirements < ActiveRecord::Migration[6.0]
  def change
    create_join_table :forwards, :requirements do |t|
      # t.index [:forward_id, :requirement_id]
      # t.index [:requirement_id, :forward_id]
    end
  end
end
