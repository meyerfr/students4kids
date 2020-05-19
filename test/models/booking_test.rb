require 'test_helper'

class BookingTest < ActiveSupport::TestCase
  test 'is_status(status) returns true if status == booking.status' do
    booking = bookings(:booking_pending_bookings_model_status)
    assert_equal true, booking.is_status?('pending')
    assert_equal false, booking.is_status?('confirmed')
    assert_equal false, booking.is_status?('declined')

    booking = bookings(:booking_confirmed_bookings_model_status)
    assert_equal false, booking.is_status?('pending')
    assert_equal true, booking.is_status?('confirmed')
    assert_equal false, booking.is_status?('declined')

    booking = bookings(:booking_declined_bookings_model_status)
    assert_equal false, booking.is_status?('pending')
    assert_equal false, booking.is_status?('confirmed')
    assert_equal true, booking.is_status?('declined')
  end

  test 'should be valid when all attributes are present' do
    booking = Booking.new(
        sitter: users(:user_sitter_bookings_model_validations),
        parent: users(:user_parent_bookings_model_validations),
        availability: availabilities(:availability_available_bookings_model_validations),
        status: "pending"
    )
    assert booking.valid?
  end

  test 'should not be valid when any attribute is not present' do
    booking = Booking.new(
        parent: users(:user_parent_bookings_model_validations),
        availability: availabilities(:availability_available_bookings_model_validations),
        status: "pending"
    )
    assert booking.invalid?

    booking = Booking.new(
        sitter: users(:user_sitter_bookings_model_validations),
        availability: availabilities(:availability_available_bookings_model_validations),
        status: "pending"
    )
    assert booking.invalid?

    booking = Booking.new(
        sitter: users(:user_sitter_bookings_model_validations),
        parent: users(:user_parent_bookings_model_validations),
        status: "pending"
    )
    assert booking.invalid?
  end
end
