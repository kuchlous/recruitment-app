require File.dirname(__FILE__) + '/../test_helper'

class HomeControllerTest < ActionController::TestCase
  def test_should_redirect_to_employee_login_page_if_not_login
    get "groups/new"
    assert_response :found
    assert_response :redirect

    login()
    get "home/index"
  end

  def test_should_send_feedback
    login()
    assert_difference('Feedback.count') do
      Resume.new(:name          => "ABC resume",
                 :file_name     => "abc_resume",
                 :summary       => "ABC comment",
                 :referral_type => "EMPLOYEE",
                 :referral_id   => 2,
                 :phone         => "+919986155860",
                 :email         => "abcdef@gmail.com",
                 :employee_id   => 2).save!
      post :feedback, :feedback => { :feedback  => 'ABC feedback',
                                     :rating    => "Good",
                                     :resume_id => Resume.find(:first, :conditions => [ "updated_at > ?", 2.seconds.ago ] ) }
      assert_equal "We thank you for submitting the feedback about this resume", flash[:notice]
    end
  end

  def test_should_search
    get "home/search"
    assert_response :redirect

    login()
    params_hash     = "search".to_sym
    sym_hash        = { "search[box]".to_sym => "First resume" }
#    params_hash.merge(sym_hash)
#    post :search, params_hash, :commit => "Search"
#    assert_not_nil assigns(:search_text)
#    assert assigns(:results)
  end

  def test_routes_should_work_as_we_want
    assert_routing 'home/actions',              { :controller => "home",         :action => "actions" }
    assert_routing 'portals/new',               { :controller => "portals",      :action => "new" }
    assert_routing 'portals/2/edit',            { :controller => "portals",      :action => "edit", :id => "2" }
    assert_routing 'groups/new',                { :controller => "groups",       :action => "new" }
    assert_routing 'groups/2/edit',             { :controller => "groups",       :action => "edit", :id => "2" }
    assert_routing 'agencies/new',              { :controller => "agencies",     :action => "new" }
    assert_routing 'agencies/2/edit',           { :controller => "agencies",     :action => "edit", :id => "2" }
    assert_routing 'requirements/new',          { :controller => "requirements", :action => "new" }
    assert_routing 'requirements/2/edit',       { :controller => "requirements", :action => "edit", :id => "2" }
  end
end
