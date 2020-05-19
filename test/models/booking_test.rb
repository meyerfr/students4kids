require 'test_helper'

class BookingTest < ActiveSupport::TestCase
  setup do
    bookings.each do |booking|
      booking.destroy
    end

    @booking = bookings(:booking_one)
    @availability = availabilities(:availability_one)
    @availability_two = availabilities(:availability_two)

    @user_parent = users(:meyer)
    @user_sitter = users(:schack)
  end

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

  test 'should validate for status' do
    assert_difference("Booking.count", +1) do
      Booking.create(
          sitter_id: @user_sitter.id,
          parent_id: @user_parent.id,
          availability_id: @availability_two.id,
          status: "pending"
      )
    end
  end
end
