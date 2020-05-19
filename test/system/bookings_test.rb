require "application_system_test_case"
require "test_helper"

class BookingsTest < ApplicationSystemTestCase
  # Testing Parent User Stories

  test "book a babysitter" do
    sign_in(users(:user_parent_bookings_e2e_make_booking))

    visit root_url
    click_on "Find A Babysitter"

    fill_in "date", with: Date.current + 31.days
    fill_in "start_time", with: "12:00:00"
    fill_in "end_time", with: "14:00:00"
    click_on "Search"

    find(".sitter").hover
    click_on "make-booking"

    click_on "submit-booking"

    assert_text "Booking was successfully created."
  end

  test "visit a booking's sitter profile" do
    sign_in(users(:user_parent_bookings_e2e_sitter_profile))
    visit root_url
    click_on "Bookings"
    find('.booking').hover
    click_on "profile"
    assert_current_path(user_path(users(:user_sitter_bookings_e2e_sitter_profile)))
  end

  test "decline a booking request as a parent" do
    sign_in(users(:user_parent_bookings_e2e_decline_booking_parent))
    visit root_url
    click_on "Bookings"
    assert_selector "h3", text: "Pending"
    find('.booking').hover
    click_on "decline"
    assert_equal(0, page.all(:css, '.booking').count)
  end

  # Testing Sitter User Stories

  test "confirm a booking request" do
    sign_in(users(:user_sitter_bookings_e2e_confirm_booking_sitter))
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
    sign_in(users(:user_sitter_bookings_e2e_decline_booking_sitter))
    visit root_url
    click_on "Bookings"
    assert_selector "h3", text: "Pending"
    find('.booking').hover
    click_on "decline"
    assert_equal(0, page.all(:css, '.booking').count)
  end

  test "visit a booking's parent profile" do
    sign_in(users(:user_sitter_bookings_e2e_parent_profile))
    visit root_url
    click_on "Bookings"
    assert_selector "h3", text: "Pending"
    find('.booking').hover
    click_on "profile"
    assert_current_path(user_path(users(:user_parent_bookings_e2e_parent_profile)))
  end
end