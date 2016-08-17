class CreateForwards < ActiveRecord::Migration
  def self.up
    create_table :forwards do |t|
      t.integer   :forwarded_to,   :null => false
      t.integer   :resume_id,      :null => false
      t.string    :status,         :default => "NEW", :limit => 15

      t.timestamps
    end
  end

  def self.down
    drop_table :forwards
  end
end
