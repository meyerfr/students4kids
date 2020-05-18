require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:meyer)
    @availability = availabilities(:availability_one)
    # sign in user
    get new_user_session_url
    sign_in(@user)
    post user_session_url

    follow_redirect!
    assert_response :success
  end

  test 'should get sitters' do
    get sitters_url, params: {
      start_time: @availability.start_time + 0.5.hours,
      end_time: @availability.end_time - 0.5.hours
    }
    assert_response :success
    assert_template 'users/sitters'
  end

  test 'should redirect to user#show path if user.role == sitter' do
    get new_user_session_url
    sign_in(users(:schack))
    post user_session_url

    follow_redirect!
    assert_response :success

    get sitters_url
    assert_redirected_to user_url(users(:schack))
    # print(@sitters)
    # assert_instance_of(Array, @sitters, @sitters)
  end

  test 'should show user' do
    # Booking between schack and meyer exist in bookings.yml
    get user_url(users(:schack))
    assert_equal(assigns(:access_to_see_all_details), true, 'should be true')
    assert_response :success
    assert_template 'users/show'
  end

  test 'should get edit' do
    get edit_user_url(@user)
    assert_response :success
    assert_template 'users/edit'
  end

  test 'should update user' do
    patch user_url(@user), params: { user: { bio: 'Hello this is a bio', dob: @user.dob, first_name: @user.first_name, last_name: @user.last_name, phone: @user.phone, role: @user.role } }
    @user.reload
    assert_equal(@user.bio, 'Hello this is a bio', 'bio should have changed')
    assert_redirected_to user_url(@user)
  end

  test 'should not update user without all attributes' do
    patch user_url(@user), params: { user: { bio: nil, dob: nil, first_name: @user.first_name, last_name: @user.last_name, phone: @user.phone, role: @user.role } }
    @user.reload
    assert_not @user.bio.nil?
    assert_not @user.dob.nil?
    # assert_redirected_to user_url(@user)
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to root_url
  end
end
