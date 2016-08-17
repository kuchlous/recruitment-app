require File.dirname(__FILE__) + '/../test_helper'

class GroupsControllerTest < ActionController::TestCase
  def test_should_get_group_list
    get :index
    assert_response :found
    assert_response :redirect

    login('alokk')
    get :index
    assert_response :success
    assert_template 'groups'
  end

  def test_should_get_group_new_page
    get :new
    assert_response :found
    assert_response :redirect

    login('alokk')
    get :new
    assert_response :success
    assert_template 'groups/new'
  end

  def test_should_not_create_group_as_employee_id_not_given
    login('alokk')
    assert_difference('Group.count', 0) do
      post :create, :group => { :name => 'ABC group' }
    end
  end

  def test_should_create_group
    login('alokk')
    assert_difference('Group.count') do
      post :create, :group => { :name        => 'ABC group',
                                :employee_id => 2 }
      @group = assigns(:group)
      assert_equal "You have successfully created group (#{@group.name})", flash[:notice]
    end
  end

  def test_should_edit_group
    get :edit
    assert_response :found
    assert_response :redirect

    login('alokk')
    get(:edit, { :id => "1" })
    assert_response :success
    assert_template 'groups/edit'
  end

end
