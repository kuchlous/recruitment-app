class RemoveAccountFromRequirements < ActiveRecord::Migration[5.2]
  def self.up
    # Remove the many-to-many join table
    drop_table :accounts_requirements if table_exists?(:accounts_requirements)
    
    # Remove the single account_id column from requirements table
    remove_column :requirements, :account_id if column_exists?(:requirements, :account_id)
  end

  def self.down
    # Recreate the join table
    create_table :accounts_requirements, :id => false do |t|
      t.integer :account_id
      t.integer :requirement_id
      t.timestamps
    end

    add_index :accounts_requirements, [:requirement_id, :account_id], :unique => true
    add_index :accounts_requirements, :requirement_id, :unique => false
    
    # Recreate the account_id column
    add_column :requirements, :account_id, :integer
  end
end 