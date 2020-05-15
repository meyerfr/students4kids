require 'test_helper'

class BookingsControllerTest < ActionDispatch::IntegrationTest
  # Setup
  setup do
    @booking = bookings(:one)
    @availability = availabilities(:one)
    @availability_two = availabilities(:two)

    @user_parent = users(:meyer)
    @user_sitter = users(:schack)

    # sign in user
    get new_user_session_url
    sign_in(@user_parent)
    post user_session_url

    follow_redirect!
    assert_response :success
  end

  test "should get index" do
    get bookings_url
    assert_response :success
  end

  test "should create booking" do
    assert_difference('Booking.count', +1) do
      post bookings_url, params: {
          booking: {
              availability_id: @availability_two.id,
              sitter_id: @user_sitter.id,
              status: "pending"
          },
          start_time: @availability_two.start_time,
          end_time: @availability_two.end_time
      }
    end

    assert_redirected_to bookings_url
  end

=begin
  test "should change booking status to confirmed" do
    assert_equal("confirmed", @booking.status) do
      confirm_booking_path(@booking)
    end
  end

  test "should change booking status to declined" do
    assert_equal("declined", @booking.status) do
      decline_booking_path(@booking)
    end
  end
=end
end
