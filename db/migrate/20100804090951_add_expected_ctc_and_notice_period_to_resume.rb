class AddExpectedCtcAndNoticePeriodToResume < ActiveRecord::Migration
  def self.up
    add_column :resumes, :expected_ctc, :float
    add_column :resumes, :notice, :integer
  end

  def self.down
    remove_column :resumes, :notice
    remove_column :resumes, :expected_ctc
  end
end
