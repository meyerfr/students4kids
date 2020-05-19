require 'test_helper'

class BookingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in(users(:user_parent_bookings_controller_index))
    get bookings_url
    assert_response :success
  end

  test "should create booking" do
    sign_in(users(:user_parent_bookings_controller_create))
    booking_sitter = users(:user_sitter_bookings_controller_create)
    booking_availability = availabilities(:availability_available_bookings_controller_create)
    assert_difference('Booking.count', +1) do
      post bookings_url, params: {
          booking: {
              availability: booking_availability,
              sitter: booking_sitter,
              status: "pending"
          },
          start_time: booking_availability.start_time,
          end_time: booking_availability.end_time
      }
    end

    assert_redirected_to bookings_url
  end

  test "should change booking status to confirmed" do
    sign_in(users(:user_parent_bookings_controller_confirm))
    booking = bookings(:booking_pending_bookings_controller_confirm)
    patch confirm_booking_path(booking)
    assert_equal("confirmed", booking.status)
  end

  test "should change booking status to declined" do
    sign_in(users(:user_parent_bookings_controller_decline))
    booking = bookings(:booking_pending_bookings_controller_decline)
    patch decline_booking_path(booking)
    assert_equal("declined", booking.status)
  end
end
