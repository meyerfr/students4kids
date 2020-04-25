require 'test_helper'

class AvailabilitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get availabilities_new_url
    assert_response :success
  end

  test "should get edit" do
    get availabilities_edit_url
    assert_response :success
  end

end
