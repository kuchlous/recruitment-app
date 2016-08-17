class CreateUniqids < ActiveRecord::Migration
  def self.up
    create_table :uniqids do |t|
      t.string       :name,             :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :uniqids
  end
end
