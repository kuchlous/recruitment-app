require File.dirname(__FILE__) + '/../test_helper'

class ResumeTest < ActiveSupport::TestCase
  def test_should_not_save_resume
    resume = Resume.new
    assert !resume.save, "Saving resume without anything, Will not be saved"
  end

  def test_should_not_save_resume_without_phone_email
    resume = Resume.new( :name          => "Test Resume",
                         :file_name     => "html_hiding_as_doc.doc",
                         :referral_type => "PORTAL",
                         :referral_id   => 2)
    assert !resume.save, "Saving the resume without phone number and emails"
  end

  def test_should_save_resume_without_file_name
    resume = Resume.new( :name          => "Test Resume",
                         :referral_type => "PORTAL",
                         :referral_id   => 2,
                         :phone         => "+919986055860",
                         :email         => "abc1@gmail.com")
    assert resume.save, "Saving the resume without uploaded file name"
  end

  def test_should_not_save_resume_as_phone_emails_are_not_in_valid_formats
    resume = Resume.new( :name           => "Test Resume",
                         :referral_type  => "PORTAL",
                         :referral_id    => 2,
                         :phone          => "+986055860",
                         :email          => "abc gail.com")
   assert !resume.save, "Saving the resume in improper formats"
  end

  def test_should_save_resume
    resume = Resume.new( :name          => "Test Resume",
                         :file_name     => "html_hiding_as_doc.doc",
                         :referral_type => "PORTAL",
                         :referral_id   => 2,
                         :phone         => "+919986055861",
                         :email         => "abc2@gmail.com")
    assert resume.save, "Resume saved"
  end

end
