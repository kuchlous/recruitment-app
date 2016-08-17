require File.dirname(__FILE__) + '/../test_helper'

class RequirementTest < ActiveSupport::TestCase
  def test_should_not_save_requirement_without_name
    requirement = Requirement.new
    assert !requirement.save, "Saving the requirement without name,
                               employee id and requirement group id"
  end

  def test_should_not_save_requirement_without_employee_id
    requirement = Requirement.new(:name => "ABC requirement")
    assert !requirement.save, "Saving the requirement without
                               employee id and group id"
  end

  def test_should_not_save_requirement_without_group_id
    requirement = Requirement.new(:name => "ABC requirement1",
                                  :employee_id => 2)
    assert !requirement.save, "Saving the requirement without group id"
  end

  def test_should_save_requirement
    requirement = Requirement.new(:name => "ABC requirement2",
                                  :employee_id => 2,
                                  :group_id => 1,
                                  :posting_emp_id => 2)
    assert requirement.save, "Requirement saved"
  end
end
