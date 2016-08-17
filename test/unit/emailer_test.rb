require File.dirname(__FILE__) + '/../test_helper'

class EmailerTest < ActionMailer::TestCase
  fixtures :employees
  fixtures :resumes

  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'

  def setup
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries         = []
    @expected = TMail::Mail.new
    @expected.set_content_type "text", "html"
    @employee          = employees(:employees_0003)
    @requirement       = requirements(:requirements_0001)
    @interview         = interviews(:interviews_0001)
  end

  def test_mail_should_go_while_forwarding_resume
    @expected.from     = "no-reply@mirafra.com"
    @expected.to       = @requirement.employee.email
    @expected.subject  = 'Resume received'
    @expected.body     = read_fixture('resumeforward')
    @expected.date     = Time.now

    emp_resume         = @employee.resumes[0]
    assert_not_nil emp_resume
    assert_not_nil @expected.encoded
    email              = Emailer.deliver_resumeforward(@employee,
                                                       @requirement.employee,
                                                       emp_resume,
                                                       emp_resume.uniqid,
                                                       @requirement,
                                                       "localhost",
                                                       "3001")
    assert_emails(1)
    assert !ActionMailer::Base.deliveries.empty?
    mail_to = @expected.to
    assert_equal [ mail_to ],                  [ email.to ]
    assert_equal [ @expected.from ],           [ email.from ]
    assert_equal [ @expected.subject],         [ email.subject ]
    assert_match /(#{@requirement.employee.name})/, email.body
    assert_match /(#{@employee.name})/,         email.body
  end

  def test_mail_should_go_while_adding_interview_panel
    @expected.from     = "no-reply@mirafra.com"
    @expected.to       = @interview.employee.email
    @expected.subject  = 'You are added to the interview panel'
    @expected.body     = read_fixture('paneladded')
    @expected.date     = Time.now

    assert_not_nil @interview
    assert_not_nil @expected.encoded
    email              = Emailer.deliver_paneladded(@interview.employee,
                                                    @interview,
                                                    @interview.req_match.resume,
                                                    "localhost",
                                                    "3001")
    assert_emails(1)
    assert !ActionMailer::Base.deliveries.empty?
    mail_to = @expected.to
    assert_equal [ mail_to ],                  [ email.to ]
    assert_equal [ @expected.from ],           [ email.from ]
    assert_equal [ @expected.subject],         [ email.subject ]
    assert_match /(#{@interview.employee.name})/, email.body
    assert_no_match /(#{@employee.name})/,        email.body
  end

  def test_mail_should_go_on_resume_action
    @expected.from     = "no-reply@mirafra.com"
    resume             = @employee.resumes[0]
    @expected.to       = resume.employee.email
    @expected.subject  = 'Resume Shortlisted'
    @expected.body     = read_fixture('resume_action')
    @expected.date     = Time.now

    assert_not_nil @interview
    assert_not_nil @expected.encoded
    email              = Emailer.deliver_resume_action(@employee,
                                                       resume,
                                                       @requirement,
                                                       "SHORTLISTED",
                                                       "SHORLISTED: Whatever comments to be passed",
                                                       "localhost",
                                                       "3001")
    assert_emails(1)
    assert !ActionMailer::Base.deliveries.empty?
    mail_to = @expected.to
    assert_equal [ mail_to ],                  [ email.to ]
    assert_equal [ @expected.from ],           [ email.from ]
    assert_equal [ @expected.subject],         [ email.subject ]
    assert_match /(#{resume.employee.name})/, email.body
    assert_match /(#{@employee.name})/,        email.body
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/emailer/#{action}.yml")
    end
end
