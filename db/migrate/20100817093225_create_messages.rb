class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|

      t.text         :message
      t.integer      :resume_id
      t.integer      :sent_to,    :null => false
      t.integer      :sent_by,    :null => false
      t.integer      :reply_to
      t.boolean      :is_deleted
      t.boolean      :is_read
      t.boolean      :is_replied
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
