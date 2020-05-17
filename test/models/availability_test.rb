require 'test_helper'

class AvailabilityTest < ActiveSupport::TestCase
  # Setup
  setup do
    @availability_one = availabilities(:availability_one)
    @availability_two = availabilities(:availability_two)
    @availability_three = availabilities(:availability_three)

    @user_parent = users(:meyer)
    @user_sitter = users(:schack)
    @user_sitter_2 = users(:lennon)
    @user_sitter_3 = users(:marley)
  end

  test 'is_status(status) returns true if status == availability.status' do
    availability = availabilities(:availability_one)
    assert_equal true, availability.is_status?('available')
    assert_equal false, availability.is_status?('requested')
    assert_equal false, availability.is_status?('booked')
  end

  test 'start_time_in_future returns nil if start_time > DateTime.now' do
    availability = availabilities(:availability_one)
    assert_nil availability.start_time_in_future
    availability = availabilities(:availability_past)
    assert_equal ["cannot be in the past."], availability.start_time_in_future
  end

  test 'minimum_time_range returns nil if end_time < (start_time + 3.hours)' do
    availability = availabilities(:availability_one)
    assert_nil availability.minimum_time_range
    availability = availabilities(:availability_3_hours)
    assert_equal ["has to be at least 3 hours after the start time."], availability.minimum_time_range
  end
end
