require "application_system_test_case"
require "test_helper"

class BookingsTest < ApplicationSystemTestCase
  setup do
    @user_parent = users(:meyer)
    @user_sitter = users(:schack)
  end

  # Testing Parent User Stories

  test "book a babysitter" do
    bookings.each do |booking|
      booking.destroy
    end

    sign_in(@user_parent)
    visit root_url
    click_on "Find A Babysitter"
    fill_in "date", with: Date.current + 31.days
    fill_in "start_time", with: "12:00:00"
    fill_in "end_time", with: "14:00:00"
    click_on "Search"
    find(".sitter").hover do
      find(".sitter-actions").click_on "book"
    end
    find(".modal-footer").click_on "submit-booking"
    assert_text "Booking was successfully created."
  end

  test "visit a booking's sitter profile" do
    sign_in(@user_parent)
    visit root_url
    click_on "Bookings"
    assert_selector "h3", text: "Pending"
    find('.booking').hover
    click_on "profile"
    assert_current_path(user_path(@user_sitter))
  end

  test "decline a booking request as a parent" do
    sign_in(@user_parent)
    visit root_url
    click_on "Bookings"
    assert_selector "h3", text: "Pending"
    find('.booking').hover
    click_on "decline"
    booking_count = 0
    find(".booking") do |booking|
      booking_count += 1
    end
    assert_equal booking_count, 1
  end

  # Testing Sitter User Stories

  test "confirm a booking request" do
    sign_in(@user_sitter)
    visit root_url
    click_on "Bookings"
    assert_selector "h3", text: "Pending"
    find('.booking').hover
    click_on "confirm"
    assert_selector "h3", text: "Confirmed"
    confirm_count = 0
    find(".booking") do |booking|
      booking.hover
      if find("#decline") && find("#profile")
        confirm_count += 1
      end
    end
    assert_equal confirm_count, 1
  end

  test "decline a booking request as a sitter" do
    sign_in(@user_sitter)
    visit root_url
    click_on "Bookings"
    assert_selector "h3", text: "Pending"
    find('.booking').hover
    click_on "decline"
    booking_count = 0
    find(".booking") do |booking|
      booking_count += 1
    end
    assert_equal booking_count, 1
  end

  test "visit a booking's parent profile" do
    sign_in(@user_sitter)
    visit root_url
    click_on "Bookings"
    assert_selector "h3", text: "Pending"
    find('.booking').hover
    click_on "profile"
    assert_current_path(user_path(@user_parent))
  end
end