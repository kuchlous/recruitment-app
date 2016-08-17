class CreateResumes < ActiveRecord::Migration
  def self.up
    create_table :resumes do |t|

      t.string          :name,      :null => false
      t.string          :file_name, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :resumes
  end
end
