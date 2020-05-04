require 'test_helper'

class BookingTest < ActiveSupport::TestCase
  test 'is_status(status) returns true if status == booking.status' do
    booking = bookings(:one)
    assert_equal true, booking.is_status?('pending')
    assert_equal false, booking.is_status?('confirmed')
    assert_equal false, booking.is_status?('declined')
  end
end
