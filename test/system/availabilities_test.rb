require "application_system_test_case"
require "test_helper"

class BookingsTest < ApplicationSystemTestCase
  setup do
    @availability_one = availabilities(:availability_one)
    @availability_two = availabilities(:availability_two)
    @availability_three = availabilities(:availability_three)
    @availability_edit = availabilities(:availability_thirteen)

    @user_sitter = users(:schack)
    @user_sitter_two = users(:marley)
    @user_sitter_three = users(:lennon)
  end

  test "create an availability" do
    sign_in(@user_sitter_two)
    visit root_url
    click_on "Availabilities"
    assert_current_path("/availabilities")
    fill_in "date", with: Date.current + 20.days
    fill_in "start_time", with: Time.current
    fill_in "end_time", with: Time.current + 180.minutes
    click_on "Create"
    assert_text "Availability was successfully created."
  end

  test "edit an availability" do
    sign_in(@user_sitter_three)
    visit root_url
    click_on "Availabilities"
    assert_current_path(availabilities_path)
    find('.availability').hover
    click_on "edit"
    assert_current_path(edit_availability_path(@availability_edit))
    fill_in "date", with: Date.current + 21.days
    fill_in "start_time", with: Time.current + 60.minutes
    fill_in "end_time", with: Time.current + 300.minutes
    click_on "Update"
    assert_current_path(availabilities_path)
    date = Date.current + 21.days
    start_time = Time.current + 60.minutes
    end_time = Time.current + 300.minutes
    assert_selector "div.availability-content h6",
                    text: "#{date.strftime('%d.%m.%y')} | #{start_time.strftime('%H:%M')} - #{end_time.strftime('%H:%M')}"
    assert_text "Availability was successfully updated."
  end

=begin
  test "delete an availability" do
    sign_in(@user_sitter_three)
    visit root_url
    click_on "Availabilities"
    assert_current_path(availabilities_path)
    find('.availability').hover
    click_on "delete"
    assert_text "Availability was successfully deleted."
  end
=end

  test "test pagination" do
    sign_in(@user_sitter)
    visit root_url

    click_on "Availabilities"
    assert_current_path(availabilities_path)

    click_on "Next Page"
    assert_current_path(availabilities_path(page: 1))

    click_on "Previous Page"
    assert_current_path(availabilities_path(page: 0))
  end
end
