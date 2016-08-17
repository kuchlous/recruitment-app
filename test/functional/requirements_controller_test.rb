require File.dirname(__FILE__) + '/../test_helper'

class RequirementsControllerTest < ActionController::TestCase
  def test_should_not_get_requirement_list
    get :index
    assert_response :found
    assert_response :redirect

    login('alokk')
    get :index
    assert_response :success
    assert_template 'requirements'
  end

  def test_should_not_get_requirement_new_page
    get :new
    assert_response :found
    assert_response :redirect

    login('alokk')
    get :new
    assert_response :success
    assert_template 'requirements/new'
  end

  def test_should_edit_requirements
    get(:edit, { :id => "1" })
    assert_response :found
    assert_response :redirect

    login('alokk')
    get(:edit, { :id => "1" })
    assert_response :success
    assert_template 'requirements/edit'
  end

  def test_should_create_requirement
    login()
    assert_difference('Requirement.count') do
      post :create, :requirement => { :name => 'ABC req',
                                      :employee_id => 2,
                                      :group_id => 2 }
      @requirement   = assigns(:requirement)
      flash[:notice] = "You have successfully created a
                        requirement (#{@requirement.name})"
    end
  end

end
