class AddLocationToResumes < ActiveRecord::Migration
  def self.up
    add_column      :resumes, :location, :string
  end

  def self.down
    remove_colulmn  :resumes, :location
  end
end
