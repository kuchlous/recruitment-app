class AddRelatedRequirementsToResume < ActiveRecord::Migration[5.2]
  def self.up
    add_column :resumes, :related_requirements, :string
  end

  def self.down
    remove_column :resumes, :related_requirements
  end
end
