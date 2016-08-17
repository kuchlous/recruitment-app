require File.dirname(__FILE__) + '/../test_helper'

class ResumesRejectedTest < ActionController::IntegrationTest
  fixtures :all

  def setup
    @employee         = employees(:employees_0003)
    @resumes          = @employee.resumes
    @logged_employee  = start_session()
  end

  def start_session()
    open_session do |sess|
      sess.extend(CustomDsl)
      sess.https!
      sess.post "employee/login", :login => "medbase",
                                  :password => "medbase123"
    end
  end

  def test_should_reject_the_resume_using_xhr
    resume          = @resumes[0]
    total_comments  = resume.comments.size
    forwards        = resume.forwards.find_all {
                        |fwd| fwd.status == "FORWARDED"
                      }
    forwards.each do |fwd|
      @logged_employee.shortlist :forward_id => fwd.id,
                                 :status => "REJECTED",
                                 "resume[comment]".to_sym => "SHORTLISTED: Resume shortlisted using Ajax"
    end
    # Ideally, it should not pass :'(
    assert_equal total_comments, resume.comments.size
  end

  module CustomDsl
    def shortlist(options)
      get "resume/resume_list"
        assert_response :success
        assert_select "#resume_comment#{Forward.find(options[:forward_id]).resume_id}", 1
      xml_http_request :put, "resume/resume_action", options
    end
  end

end
