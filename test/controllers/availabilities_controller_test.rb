require 'test_helper'

class AvailabilitiesControllerTest < ActionDispatch::IntegrationTest
  # Index Tests
  test "should get index" do
    sign_in(users(:user_sitter_availabilities_controller_index))
    get availabilities_path
    assert_response :success
    assert_template 'availabilities/index'
  end

  # Create Tests
  test 'should create availability' do
    sign_in(users(:user_sitter_availabilities_controller_create))
    assert_difference('Availability.count', +1) do
      post availabilities_path, params: {
          date: "2020-06-04",
          start_time: "10:00:00",
          end_time: "18:00:00"
      }
    end

    assert_redirected_to availabilities_path
  end

  test 'should not create availability with end_time less than three hours later than start_time' do
    sign_in(users(:user_sitter_availabilities_controller_create))
    assert_difference('Availability.count', 0) do
      post availabilities_path, params: {
          date: "2020-06-04",
          start_time: "10:00:00",
          end_time: "12:00:00"
      }
    end

    assert_redirected_to availabilities_path
  end

  test 'should not create availability with start_time or end_time in the past' do
    sign_in(users(:user_sitter_availabilities_controller_create))
    assert_difference('Availability.count', 0) do
      post availabilities_path, params: {
          date: Date.today.change(day: Date.today.day - 1),
          start_time: "10:00:00",
          end_time: "12:00:00"
      }
    end

    assert_redirected_to availabilities_path
  end

  test 'should not create availabilities with overlapping times' do
    sign_in(users(:user_sitter_availabilities_controller_create))
    assert_difference('Availability.count', +1) do
      post availabilities_path, params: {
          date: "2020-06-04",
          start_time: "17:00:00",
          end_time: "20:00:00"
      }
    end

    assert_redirected_to availabilities_path
  end

  # Edit Tests
  test "should get edit" do
    sign_in(users(:user_sitter_availabilities_controller_edit_update_destroy))
    get edit_availability_url(availabilities(:availability_valid_availabilities_controller_edit_update_destroy))
    assert_response :success
  end

  # Update Tests
  test 'should update availability' do
    sign_in(users(:user_sitter_availabilities_controller_edit_update_destroy))
    patch availability_url(availabilities(:availability_valid_availabilities_controller_edit_update_destroy)), params: {
        date: "2020-06-03",
        start_time: "10:00:00",
        end_time: "18:00:00",
    }

    assert_redirected_to availabilities_path
  end

  test 'should not update availability with end_time less than three hours later than start_time' do
    sign_in(users(:user_sitter_availabilities_controller_edit_update_destroy))
    patch availability_url(availabilities(:availability_valid_availabilities_controller_edit_update_destroy)), params: {
        date: "2020-06-04",
        start_time: "10:00:00",
        end_time: "12:00:00",
    }

    assert_redirected_to availabilities_path
  end

  test 'should not update availability with start_time or end_time in the future' do
    sign_in(users(:user_sitter_availabilities_controller_edit_update_destroy))
    patch availability_url(availabilities(:availability_valid_availabilities_controller_edit_update_destroy)), params: {
        date: Date.today.change(day: Date.today.day - 1),
        start_time: "10:00:00",
        end_time: "12:00:00",
    }

    assert_redirected_to availabilities_path
  end

  test 'should not update availabilities with overlapping times' do
    sign_in(users(:user_sitter_availabilities_controller_edit_update_destroy))
    patch availability_url(availabilities(:availability_valid_availabilities_controller_edit_update_destroy)), params: {
        date: "2020-06-04",
        start_time: "17:00:00",
        end_time: "20:00:00",
    }

    assert_redirected_to availabilities_path
  end

  # Destroy Tests
  test 'should destroy availability' do
    assert_difference('Availability.count', -1) do
      sign_in(users(:user_sitter_availabilities_controller_edit_update_destroy))
      delete availability_url(availabilities(:availability_valid_availabilities_controller_edit_update_destroy))
    end

    assert_redirected_to availabilities_path
  end

  # Sitter Authentication Tests
  test 'should authenticate user with role "sitter"' do
    sign_in(users(:user_sitter_availabilities_controller_authenticate))
    get availabilities_path
    assert_response :success
  end

  test 'should not authenticate user with role "parent"' do
    sign_in(users(:user_parent_availabilities_controller_authenticate))
    get availabilities_path
    assert_redirected_to root_path
  end

  # Page Count Tests
  test 'page counter should return 1 for 15 availabilities' do
    sign_in(users(:user_sitter_availabilities_controller_page_counter_15))
    get availabilities_path
    assert_response :success
    assert_equal(1.5, assigns(:page_count))
  end

  test 'page counter should return 0.3 for 3 availabilities' do
    sign_in(users(:user_sitter_availabilities_controller_page_counter_3))
    get availabilities_path
    assert_response :success
    assert_equal(0.3, assigns(:page_count))
  end

  test 'page counter should return 0 for 0 availabilities' do
    sign_in(users(:user_sitter_availabilities_controller_page_counter_0))
    get availabilities_path
    assert_response :success
    assert_equal(0, assigns(:page_count))
  end
end
