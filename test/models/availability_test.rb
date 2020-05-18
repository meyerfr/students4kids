require 'test_helper'

class AvailabilityTest < ActiveSupport::TestCase
  test 'is_status(status) returns true if status == availability.status' do
    availability = availabilities(:availability_available_availabilities_model_status)
    assert_equal true, availability.is_status?('available')
    assert_equal false, availability.is_status?('requested')
    assert_equal false, availability.is_status?('booked')

    availability = availabilities(:availability_requested_availabilities_model_status)
    assert_equal false, availability.is_status?('available')
    assert_equal true, availability.is_status?('requested')
    assert_equal false, availability.is_status?('booked')

    availability = availabilities(:availability_booked_availabilities_model_status)
    assert_equal false, availability.is_status?('available')
    assert_equal false, availability.is_status?('requested')
    assert_equal true, availability.is_status?('booked')
  end

  test 'start_time_in_future returns nil if start_time > DateTime.now' do
    availability = availabilities(:availability_future_availabilities_model_future_start_time)
    assert_nil availability.start_time_in_future
    assert availability.valid?
    availability = availabilities(:availability_past_availabilities_model_future_start_time)
    assert_equal ["cannot be in the past."], availability.start_time_in_future
    assert availability.invalid?
  end

  test 'minimum_time_range returns nil if end_time < (start_time + 3.hours)' do
    availability = availabilities(:availability_one)
    assert_nil availability.minimum_time_range
    assert availability.valid?
    availability = availabilities(:availability_3_hours)
    assert_equal ["has to be at least 3 hours after the start time."], availability.minimum_time_range
    assert availability.invalid?
  end

  test 'availability is invalid when overlapping with existing availability' do
    availability = Availability.new(
        start_time: availabilities(:availability_one).start_time,
        end_time: availabilities(:availability_one).end_time,
        sitter: availabilities(:availability_one).sitter
    )
    assert availability.invalid?
  end

  test 'availability is valid when all attributes are filled in' do
    availability = Availability.new(
        start_time: DateTime.current + 1.days,
        end_time: DateTime.current + 1.days + 3.hours,
        sitter: users(:marley),
        status: "available"
    )
    assert availability.valid?
  end

  test 'availability is invalid when any of the attributes are missing' do
    availability = Availability.new(
        end_time: DateTime.current + 1.days + 3.hours,
        sitter: users(:marley),
        status: "available"
    )
    assert availability.invalid?

    availability = Availability.new(
        start_time: DateTime.current + 1.days,
        sitter: users(:marley),
        status: "available"
    )
    assert availability.invalid?

    availability = Availability.new(
        start_time: DateTime.current + 1.days,
        end_time: DateTime.current + 1.days + 3.hours,
        status: "available"
    )
    assert availability.invalid?
  end
end
