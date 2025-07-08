class CreateAgencies < ActiveRecord::Migration[5.2]
  def self.up
    create_table :agencies do |t|
      t.string   :name, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :agencies
  end
end
