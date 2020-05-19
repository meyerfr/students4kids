require 'test_helper'

class BookingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in(users(:user_parent_bookings_controller_index))
    get bookings_url
    assert_response :success
  end

  test "should create booking" do
    sign_in(users(:user_parent_bookings_controller_create))
    booking_parent = users(:user_parent_bookings_controller_create)
    booking_sitter = users(:user_sitter_bookings_controller_create)
    booking_availability = availabilities(:availability_available_bookings_controller_create)
    # assert_difference'Booking.count' do
      post bookings_path(
          booking: {
              availability_id: booking_availability.id,
              parent_id: booking_parent.id,
              sitter_id: booking_sitter.id,
              status: "pending"
          },
          start_time: booking_availability.start_time + 30.minutes,
          end_time: booking_availability.end_time - 30.minutes
       )
    # end

    assert_redirected_to bookings_path
    assert_equal 'Booking was successfully created.', flash[:notice]
  end

  test "should change booking status to confirmed" do
    sign_in(users(:user_parent_bookings_controller_confirm))
    booking = bookings(:booking_pending_bookings_controller_confirm)
    patch confirm_booking_path(booking)
    booking.reload
    assert_equal("confirmed", booking.status)
  end

  test "should change booking status to declined" do
    sign_in(users(:user_parent_bookings_controller_decline))
    booking = bookings(:booking_pending_bookings_controller_decline)
    patch decline_booking_path(booking)
    booking.reload
    assert_equal("declined", booking.status)
  end
end
