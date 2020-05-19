require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_sitter_users_controller_general)
    sign_in(@user)
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
    patch user_url(@user), params: {
        user: {
            bio: @user.bio,
            dob: @user.dob,
            first_name: @user.first_name,
            last_name: @user.last_name,
            phone: @user.phone,
            role: @user.role
        }
    }
    assert_redirected_to user_url(@user)
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to root_url
  end

  test 'should redirect to user#show path if user.role == sitter' do
    get sitters_url
    assert_redirected_to user_url(@user)
  end
end
