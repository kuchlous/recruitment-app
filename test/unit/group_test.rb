require File.dirname(__FILE__) + '/../test_helper'

class GroupTest < ActiveSupport::TestCase
  def test_should_not_save_group_without_name
    group = Group.new
    assert !group.save, "Saving the group without name"
  end

  def test_should_not_save_group_without_employee_id
    group = Group.new(:name => "ABC Group")
    assert !group.save, "Saving the group without employee_id"
  end

  def test_should_save_group_now
    group_object_size = Group.all.size
    group = Group.new(:name => "ABC Group New",
                      :employee_id => 2)
    assert group.save, "Saved GROUP"
    assert_equal("ABC Group New", group.name)
    assert_equal(group_object_size+1, Group.all.size)
  end

  def test_should_not_save_group_as_name_already_in_database
    group = Group.new(:name => "Software",
                      :employee_id => 2)
    assert !group.save, "Saving group with name that
                         is already in database"
  end

  def test_should_update_group
    latest_group_updated = Group.find(:first,
                                      :order => "updated_at DESC")
    assert latest_group_updated.update_attributes(:name => "Updating Group"),
                                                  "Updating group name"
  end

  def test_should_not_update_group
    latest_group_updated = Group.find(:first,
                                      :order => "updated_at DESC")
    assert !latest_group_updated.update_attributes(:name => "Verification"),
                                                   "Saving the group with name that
                                                    is already in our database"
  end
end
