class JoinTableForRequirementAndAccount < ActiveRecord::Migration
  def self.up
    create_table :accounts_requirements, :id => false do |t|
      t.integer :account_id
      t.integer :requirement_id

      t.timestamps
    end

    add_index :accounts_requirements, [:requirement_id, :account_id], :unique => true
    add_index :accounts_requirements,  :requirement_id,               :unique => false
  end

  def self.down
    drop_table :accounts_requirements
  end
end
