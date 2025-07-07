class AddLocationToResumes < ActiveRecord::Migration[5.2]
  def self.up
    add_column      :resumes, :location, :string
  end

  def self.down
    remove_colulmn  :resumes, :location
  end
end
