require File.dirname(__FILE__) + '/../test_helper'

class DesignationsControllerTest < ActionController::TestCase
  def test_should_get_designation_list
    get :index
    assert_response :found
    assert_response :redirect

    login('alokk')
    get :index
    assert_response :success
    assert_template 'designations'
  end

  def test_should_get_designation_new_page
    get :new
    assert_response :found
    assert_response :redirect

    login('alokk')
    get :new
    assert_response :success
    assert_template 'designations/new'
  end

  def test_should_create_designation
    login('alokk')
    assert_difference('Designation.count') do
      post :create, :designation => { :name => 'ABC Designation' }
      assert_equal "#{@designation.name} added successfully", flash[:notice]
    end
  end

  def test_should_edit_designation
    get :edit
    assert_response :found
    assert_response :redirect

    login('alokk')
    get(:edit, { :id => "1" })
    assert_response :success
    assert_template 'designations/edit'
  end

end
