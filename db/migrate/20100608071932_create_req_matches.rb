class CreateReqMatches < ActiveRecord::Migration
  def self.up
    create_table :req_matches do |t|
      t.integer    :forwarded_to,   :null    => false
      t.integer    :resume_id,      :null    => false
      t.integer    :requirement_id, :null    => false
      t.string     :status,         :default => "NEW", :limit => 15

      t.timestamps
    end
  end

  def self.down
    drop_table :req_matches
  end
end
