require 'test_helper'

class AvailabilitiesControllerTest < ActionDispatch::IntegrationTest
  # Setup
  setup do
    @availability_one = availabilities(:one)
    @availability_two = availabilities(:two)
    @availability_three = availabilities(:three)

    @user_parent = users(:meyer)
    @user_sitter = users(:schack)
    @user_sitter_2 = users(:lennon)
    @user_sitter_3 = users(:marley)

    # sign in user
    get new_user_session_url
    sign_in(@user_sitter)
    post user_session_url

    follow_redirect!
    assert_response :success
  end

  # Index Tests
  test "should get index" do
    get availabilities_url
    assert_response :success
    assert_template 'availabilities/index'
  end

  # Create Tests
  test 'should create availability' do
    assert_difference('Availability.count', +1) do
      post availabilities_url, params: {
          date: "2020-06-04",
          start_time: "10:00:00",
          end_time: "18:00:00",
      }
    end

    assert_redirected_to availabilities_url
  end

  test 'should not create availability with end_time less than three hours later than start_time' do
    assert_difference('Availability.count', 0) do
      post availabilities_url, params: {
          date: "2020-06-04",
          start_time: "10:00:00",
          end_time: "12:00:00",
      }
    end

    assert_redirected_to availabilities_url
  end

  test 'should not create availability with start_time or end_time in the past' do
    assert_difference('Availability.count', 0) do
      post availabilities_url, params: {
          date: Date.today.change(day: Date.today.day - 1),
          start_time: "10:00:00",
          end_time: "12:00:00",
      }
    end

    assert_redirected_to availabilities_url
  end

  test 'should not create availabilities with overlapping times' do
    assert_difference('Availability.count', +1) do
      post availabilities_url, params: {
          date: "2020-06-04",
          start_time: "17:00:00",
          end_time: "20:00:00",
      }
    end

    assert_redirected_to availabilities_url
  end

  # Edit Tests
  test "should get edit" do
    get edit_availability_url(@availability_three)
    assert_response :success
  end

  # Update Tests
  test 'should update availability' do
    patch availability_url(@availability_three), params: {
        date: "2020-06-03",
        start_time: "10:00:00",
        end_time: "18:00:00",
    }

    assert_redirected_to availabilities_url
  end

  test 'should not update availability with end_time less than three hours later than start_time' do
    patch availability_url(@availability_three), params: {
        date: "2020-06-04",
        start_time: "10:00:00",
        end_time: "12:00:00",
    }

    assert_redirected_to availabilities_url
  end

  test 'should not update availability with start_time or end_time in the future' do
    patch availability_url(@availability_three), params: {
        date: Date.today.change(day: Date.today.day - 1),
        start_time: "10:00:00",
        end_time: "12:00:00",
    }

    assert_redirected_to availabilities_url
  end

  test 'should not update availabilities with overlapping times' do
    patch availability_url(@availability_three), params: {
        date: "2020-06-04",
        start_time: "17:00:00",
        end_time: "20:00:00",
    }

    assert_redirected_to availabilities_url
  end

  # Destroy Tests
  test 'should destroy availability' do
    assert_difference('Availability.count', -1) do
      delete availability_url(@availability_three)
    end

    assert_redirected_to availabilities_url
  end

  # Sitter Authentication Tests
  test 'should authenticate user with role "sitter"' do
    get availabilities_url
    assert_response :success
  end

  test 'should not authenticate user with role "parent"' do
    get new_user_session_url
    sign_in(@user_parent)
    post user_session_url

    follow_redirect!
    assert_response :success

    get availabilities_url

    assert_redirected_to root_url
  end

  # Page Count Tests
  test 'page counter should return 1 for > 10 availability' do
    get availabilities_url
    assert_response :success
    assert_equal(1, assigns(:page_count))
  end

  test 'page counter should return 0 for 1 availability' do
    get new_user_session_url
    sign_in(@user_sitter_2)
    post user_session_url

    follow_redirect!
    assert_response :success

    get availabilities_url
    assert_response :success
    assert_equal(0, assigns(:page_count))
  end

  test 'page counter should return 0 for 0 availabilities' do
    get new_user_session_url
    sign_in(@user_sitter_3)
    post user_session_url

    follow_redirect!
    assert_response :success

    get availabilities_url
    assert_response :success
    assert_equal(0, assigns(:page_count))
  end
end