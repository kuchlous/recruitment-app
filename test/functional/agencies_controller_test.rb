require File.dirname(__FILE__) + '/../test_helper'

class AgenciesControllerTest < ActionController::TestCase
  def test_should_get_agency_list
    get :index
    assert_response :found
    assert_response :redirect

    login('alokk')
    get :index
    assert_response :success
  end

  def test_should_get_agency_new_page
    get :new
    assert_response :found
    assert_response :redirect

    login('alokk')
    get :new
    assert_response :success
  end

  def test_should_create_agency
    login('alokk')
    assert_difference('Agency.count') do
      post :create, :agency => { :name => 'ABC agency' }
      assert_equal "Please press F5 once if you are adding
                          this agency in employee referral", flash[:notice]
    end
  end

  def test_should_edit_agency
    get :edit
    assert_response :found
    assert_response :redirect

    login('alokk')
    get(:edit, { :id => "1" })
    assert_response :success
    assert_template 'agencies/edit'
  end
end
