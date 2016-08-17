class AddStageTypeFocusToInterviews < ActiveRecord::Migration
  def self.up
    add_column :interviews, :stage, :string
    add_column :interviews, :itype,  :string
    add_column :interviews, :focus, :text
  end

  def self.down
    remove_column :interviews, :stage
    remove_column :interviews, :itype
    remove_column :interviews, :focus
  end
end
