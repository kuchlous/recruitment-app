class CreateJoinTableForReqsAndForwards < ActiveRecord::Migration
  def self.up
    create_table :forwards_requirements, :id => false do |t|
      t.integer :forward_id
      t.integer :requirement_id

      t.timestamps
    end

    add_index :forwards_requirements, [ :requirement_id, :forward_id ], :unique  => true
    add_index :forwards_requirements,   :requirement_id,                :uniqiue => false
  end

  def self.down
    drop_table :forwards_requirements
  end
end
