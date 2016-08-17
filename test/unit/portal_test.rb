require File.dirname(__FILE__) + '/../test_helper'

class PortalTest < ActiveSupport::TestCase
  def test_should_not_save_portal
    portal             = Portal.new
    assert !portal.save, "Saving the portal without name"
  end

  def test_should_not_save_portal_with_same_name_and_save_with_diff_name
    portal_object_size = Portal.all.size
    portal             = Portal.new(:name => "Abc Portal")
    assert portal.save, "Saving the portal with name that
                         is not present in our database"
    assert_equal("Abc Portal", portal.name)
    assert_equal(portal_object_size+1, Portal.all.size)
  end

  def test_should_not_save_portal_as_name_already_in_database
    portal_same_name   = Portal.new(:name => "Job Dhoondo")
    assert !portal_same_name.save, "Saving the portal with name
                                    that is already in our database"
  end

  def test_should_update_portal
    latest_updated_portal = Portal.find(:first,
                                        :order => "updated_at DESC")
    assert latest_updated_portal.update_attributes(:name => "Updating Portal"),
                                                   "Updating portal name"
  end

  def test_should_not_update_group
    latest_updated_portal = Portal.find(:first,
                                        :order => "updated_at DESC")
    assert !latest_updated_portal.update_attributes(:name => "Times Job"),
                                                    "Saving the portal with name that
                                                     is already in our database"
  end
end
