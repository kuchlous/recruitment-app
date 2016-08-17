require File.dirname(__FILE__) + '/../test_helper'

class ResumesControllerTest < ActionController::TestCase
  def setup
    @request.env["HTTP_REFERER"] = "http://localhost:3001/resumes/forwarded"
  end

  def test_should_not_access_pages_without_login
    get "resumes/new"
      assert_response :redirect
    get "resumes/forwarded"
      assert_response :redirect
    get "resumes/download_resume"
      assert_response :redirect
    get "resumes/interview_requests"
      assert_response :redirect
    get "resumes/hold"
      assert_response :redirect
    get "resumes/offered"
      assert_response :redirect
    get "resumes/joined"
      assert_response :redirect
  end

  def test_should_access_pages_with_sessions_created
    login('alokk')
    get "resumes/new"
      assert_response :success
    get "resumes/forwarded"
      assert_response :success
    get "resumes/download_resume"
      assert_response :success
    get "resumes/interview_requests"
      assert_response :success
    get "resumes/hold"
      assert_response :success
    get "resumes/offered"
      assert_response :success
    get "resumes/joined"
      assert_response :success
  end

  def test_should_not_save_resume_as_uploaded_file_not_given
    login('alokk')
    assert_difference('Resume.count', 0) do
      post :create, :resume => {
           :name          => "ABC resume",
           :file_name     => "abc_resume",
           :summary       => "ABC comment",
           :referral_type => "EMPLOYEE",
           :referral_id   => 2
      }
      assert_equal "Please select resume first", flash[:notice]
    end
    assert_response :redirect
  end

  def test_should_save_resume_as_uploaded_file_given
    login('alokk')
    assert_difference('Resume.count') do
      post :create, :resume => {
           :upload_resume  => fixture_file_upload('First_Resume.doc', "application/msword"),
           :name           => "ABC resume",
           :file_name      => "abc_resume",
           :summary        => "ABC comment",
           :referral_type  => "EMPLOYEE",
           :referral_id    => 2,
           :experience     => "4-5",
           :phone          => "+911234567895",
           :email          => "abcd2@gmail.com"
      }, :requirement_name => 1
      assert_equal "You have successfully uploaded resume and is forwarded to
                                  the people who are the owner of the requirement
                                  that you selected", flash[:notice]
    end
    assert_response :redirect
  end


  def test_should_not_get_resume_details_page_before_login_and_get_after_logged_in
    resume_file_name = Resume.find(:first, :conditions => [ "updated_at > ?", 1.minutes.ago ] ).file_name
    get(:show, { :id => resume_file_name } )
      assert_response :found
      assert_response :redirect

    login('alokk')
    get(:show, { :id => resume_file_name })
      assert_response :success
      assert_template "resumes/show"
  end

  def test_should_not_add_interview_as_interview_date_not_given
    get "resumes/forwarded"
      assert_response :redirect

    login('alokk')
    get "resumes/forwarded"
      assert_response :success

    assert_difference('Interview.count', 0) do
      post :add_interviews, :interview_employee_name0 => "2",
                            :time_slot0               => "07:00",
                            :forward_id_hidden_value  => "1"
      assert_equal "Interview date can't be blank", flash[:notice]
    end
    assert_response :redirect
  end

  def test_should_not_add_interview_because_date_is_earlier_than_today
    login('alokk')
    assert_difference('Interview.count', 0) do
      post :add_interviews, :interview_employee_name0    => "2",
                            :interview_date0             => "2010-03-23",
                            :time_slot0                  => "07:00",
                            :forward_id_hidden_value     => "1"
      resume         = Forward.find(1).resume
      assert_equal "Interviews date can not be earlier than today", flash[:notice]
      assert !ActionMailer::Base.deliveries.empty?
    end
    assert_response :redirect
  end

  def test_should_add_interview
    login('alokk')
    assert_difference('Interview.count') do
      post :add_interviews, :interview_employee_name0    => "2",
                            :interview_date0             => "2010-07-23",
                            :time_slot0                  => "07:00",
                            :forward_id_hidden_value     => "1"
      resume         = Forward.find(1).resume
      assert_equal "You have succesfully added the interview schedule
                          for #{resume.name} (#{Requirement.find(1).name}).
                          Mail has also been sent to the panel members.", flash[:notice]
      assert !ActionMailer::Base.deliveries.empty?
    end
    assert_response :redirect
  end

  def test_should_not_forward_resume_to_another_employee_as_requirement_not_selected
    get "resumes/forwarded"
      assert_response :redirect

    login('alokk')
    get "resumes/forwarded"
      assert_response :success

    assert_difference('Forward.count', 0) do
      post :forwarding_to_another_employee, :forward_id => 1
      assert_equal "Massive error in forwarding this resume to concerned employee.
              May be you did not select the requirement name from the list.", flash[:notice]
    end
    assert_response :redirect
  end

  def test_should_forward_resume_to_another_employee
    login('alokk')
    assert_difference('Forward.count') do
      post :forwarding_to_another_employee, :requirement_name => 1,
                                            :forward_id       => 1
      assert_equal "You have forwarded this resume to #{Requirement.find(1).employee.name}
              who is the owner of the requirement.", flash[:notice]
      assert !ActionMailer::Base.deliveries.empty?
    end
    assert_response :redirect
  end
end
