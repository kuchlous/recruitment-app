class AddSomeMoreColumnsToResumes < ActiveRecord::Migration
  def self.up
    add_column :resumes, :experience,    :string
    add_column :resumes, :qualification, :text
    add_column :resumes, :ctc,           :float
  end

  def self.down
    remove_column :resumes, :experience
    remove_column :resumes, :qualification
    remove_column :resumes, :ctc
  end
end
