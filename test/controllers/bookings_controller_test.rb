require 'test_helper'

class BookingsControllerTest < ActionDispatch::IntegrationTest
  # Setup
  setup do
    @booking = bookings(:booking_one)
    @availability = availabilities(:availability_one)
    @availability_two = availabilities(:availability_two)

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

=begin
  test "should create booking" do
    print(bookings.to_a)
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
=end

  test "should change booking status to confirmed" do
    print(confirm_booking_url(@booking))
    assert_changes -> { @booking.status }, 'Expected the status to be confirmed' do
      patch confirm_booking_url(@booking)
    end
    assert_redirected_to bookings_url
    # print(@booking.status)
  end

  test "should change booking status to declined" do
    assert_equal("declined", @booking.status) do
      get decline_booking_url(@booking.id)
    end
  end

end
