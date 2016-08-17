require File.dirname(__FILE__) + '/../test_helper'

class AgencyTest < ActiveSupport::TestCase
  def test_should_not_save_agency
    agency             = Agency.new
    assert !agency.save, "Saving the agency without name"
  end

  def test_should_not_save_agency_with_same_name_and_save_with_diff_name
    agency_object_size = Agency.all.size
    agency             = Agency.new(:name => "Abc Consulting")
    assert agency.save, "Saving the agency with name that
                         is not present in our database"
    assert_equal("Abc Consulting", agency.name)
    assert_equal(agency_object_size+1, Agency.all.size)

    agency_same_name   = Agency.new(:name => "Mind Consulting")
    assert !agency_same_name.save, "Saving the agency with name that
                                    is already in our database"

    agency_same_name   = Agency.new(:name => "Abc Consulting")
    assert !agency_same_name.save, "Saving the agency with name that
                                    is already in our database"
  end

  def test_should_update_agency
    agency_latest_updated = Agency.find( :first,
                                         :order => "updated_at DESC" )
    assert agency_latest_updated.update_attributes(:name => "Whatever consulting"),
                                                   "Updating agency name"
  end

  def test_should_not_update_agency_with_same_name
    agency_latest_updated = Agency.find( :first,
                                         :order => "updated_at DESC" )
    assert !agency_latest_updated.update_attributes(:name => "Heads and Brains"),
                                                    "Saving the agency with name that is
                                                     already in our database"
  end

end
