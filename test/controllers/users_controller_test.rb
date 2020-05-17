require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:schack)
    # sign in user
    get new_user_session_url
    sign_in(@user)
    post user_session_url

    follow_redirect!
    assert_response :success
  end

  test 'should show user' do
    get user_url(@user)
    assert_response :success
  end

  test 'should get edit' do
    get edit_user_url(@user)
    assert_response :success
  end

  test 'should update user' do
    patch user_url(@user), params: { user: { bio: @user.bio, dob: @user.dob, first_name: @user.first_name, last_name: @user.last_name, phone: @user.phone, role: @user.role } }
    assert_redirected_to user_url(@user)
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to root_url
  end

  # test 'should show all sitters in the radius and with given availability if user.role == parent' do

  # end

  test 'should redirect to user#show path if user.role == sitter' do
    get sitters_url
    assert_redirected_to user_url(@user)
    # print(@sitters)
    # assert_instance_of(Array, @sitters, @sitters)
  end

  # test 'should return redirect to user#show unless user.is_role?(role) == parent' do
  #   @controller = UsersController.new
  #   @controller.instance_eval{ authenticate_parent! }   # invoke the private method
  #   @controller.instance_eval{ @current_account }.should eql user_user() # check the value of the instance variable
  # end
end
