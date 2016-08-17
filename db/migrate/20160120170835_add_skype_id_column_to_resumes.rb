class AddSkypeIdColumnToResumes < ActiveRecord::Migration
  def self.up
    add_column :resumes, :skype_id,     :string
  end

  def self.down
    remove_column :resumes, :skype_id
  end
end
