require File.dirname(__FILE__) + '/../test_helper'

class DesignationTest < ActiveSupport::TestCase
  def test_should_not_save_designation
    designation             = Designation.new
    assert !designation.save, "Saving the designation without name"
  end

  def test_should_not_save_designation_with_same_name_and_save_with_diff_name
    designation_object_size = Designation.all.size
    designation             = Designation.new(:name => "Software Engineer")
    assert designation.save, "Saving the designation with name that
                              is not present in our database"
    assert_equal("Software Engineer", designation.name)
    assert_equal(designation_object_size+1, Designation.all.size)
  end

  def test_should_not_save_designation_as_name_already_in_database
    designation_same_name   = Designation.new(:name => "SSE")
    assert !designation_same_name.save, "Saving the designation with name
                                         that is already in our database"
  end

  def test_should_update_designation
    latest_updated_designation = Designation.find(:first,
                                                  :order => "updated_at DESC")
    assert latest_updated_designation.update_attributes(:name => "Updating Designation"),
                                                                 "Updating designation name"
  end

  def test_should_not_update_designation
    latest_updated_designation = Designation.find(:first,
                                                  :order => "updated_at DESC")
    assert !latest_updated_designation.update_attributes(:name => "SSE"),
                                                                  "Saving the designation with name that
                                                                   is already in our database"
  end
end
