require File.dirname(__FILE__) + '/../test_helper'

class PortalsControllerTest < ActionController::TestCase
  def test_should_get_portal_list
    get :index
    assert_response :found
    assert_response :redirect

    login('alokk')
    get :index
    assert_response :success
    assert_template 'portals'
  end

  def test_should_get_portal_new_page
    get :new
    assert_response :found
    assert_response :redirect

    login('alokk')
    get :new
    assert_response :success
    assert_template 'portals/new'
  end

  def test_should_create_portal
    login('alokk')
    assert_difference('Portal.count') do
      post :create, :portal => { :name => 'ABC Portal' }
      assert_equal "Please press F5 once if you are adding
                          this portal in employee referral", flash[:notice]
    end
  end

  def test_should_edit_portal
    get :edit
    assert_response :found
    assert_response :redirect

    login('alokk')
    get(:edit, { :id => "1" })
    assert_response :success
    assert_template 'portals/edit'
  end

end
