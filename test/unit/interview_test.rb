require File.dirname(__FILE__) + '/../test_helper'

class InterviewTest < ActiveSupport::TestCase
  def test_should_not_save_interview
    interview = Interview.new()
    assert !interview.save, "Saving the interivew without
                             employee_id, date and time"
  end

  def test_should_not_save_interview_without_date_time
    interview = Interview.new(:employee_id => 2)
    assert !interview.save, "Saving the interivew without
                             date and time"
  end

  def test_should_not_save_interview_with_date_earlier_than_today
    interview_size = Interview.all.size
    interview = Interview.new(:employee_id => 2,
                              :interview_date => "2010-03-23",
                              :interview_time => "07:00")
    assert !interview.save, "Saving interview earlier than today's date"
  end

  def test_should_save_interview
    interview_size = Interview.all.size
    interview = Interview.new(:employee_id => 2,
                              :interview_date => "2010-07-23",
                              :interview_time => "07:00")
    assert interview.save, "Interviews Saved"
    assert_equal(interview_size+1, Interview.all.size)
  end
end
