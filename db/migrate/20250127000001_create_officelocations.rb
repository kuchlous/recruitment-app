class CreateOfficelocations < ActiveRecord::Migration[5.2]
  def change
    create_table :officelocations do |t|
      t.string :name, null: false
      t.text :address
      t.string :city
      t.string :state
      t.string :pincode

      t.timestamps
    end

    add_index :officelocations, :name
    add_index :officelocations, :city
    add_index :officelocations, :state
  end
end
