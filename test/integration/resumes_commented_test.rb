require File.dirname(__FILE__) + '/../test_helper'

class ResumesCommentedTest < ActionController::IntegrationTest
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
      sess.post "home/login", :login => "medbase",
                              :password => "medbase123"
    end
  end

  def test_should_comment_the_resume_using_xhr
    resume          = @resumes[0]
    total_comments  = resume.comments.size
    @logged_employee.add_comment :forward_id => resume.id, "resume[comment]".to_sym => "COMMENTED: Why should i give comment here?"
    assert_equal total_comments, resume.comments.size
  end

  module CustomDsl
    def add_comment(options)
      get "resumes/resume_list"
        assert_response :success
      xml_http_request :put, "resume/add_resume_comments", options
    end
  end

end
