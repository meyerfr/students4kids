require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:lennon)
  end

  test 'user registration' do
    visit new_user_registration_url
    assert_selector 'h2', text: 'Sign up'
    fill_in 'First name', with: @user.first_name
    fill_in 'Last name', with: @user.last_name
    fill_in 'Email', with: @user.email
    fill_in 'user_password', with: @user.encrypted_password
    fill_in 'user_password_confirmation', with: @user.encrypted_password
    click_on 'Sign up'
    assert_text "User was successfully created"
  end

  # test 'user registration' do
  #   sign_in @user
  #   visit users_url
  #   assert_selector 'h1', text: 'Sitters'

  #   # assert_text 'User was successfully created'
  # end

  # test "visiting the index" do
  #   visit users_url
  #   assert_selector "h1", text: "Users"
  # end

  # test "creating a User" do
  #   visit users_url
  #   click_on "New User"

  #   fill_in "Bio", with: @user.bio
  #   fill_in "Dob", with: @user.dob
  #   fill_in "First name", with: @user.first_name
  #   fill_in "Last name", with: @user.last_name
  #   fill_in "Phone", with: @user.phone
  #   fill_in "Role", with: @user.role
  #   click_on "Create User"

  #   assert_text "User was successfully created"
  #   click_on "Back"
  # end

  # test "updating a User" do
  #   visit users_url
  #   click_on "Edit", match: :first

  #   fill_in "Bio", with: @user.bio
  #   fill_in "Dob", with: @user.dob
  #   fill_in "First name", with: @user.first_name
  #   fill_in "Last name", with: @user.last_name
  #   fill_in "Phone", with: @user.phone
  #   fill_in "Role", with: @user.role
  #   click_on "Update User"

  #   assert_text "User was successfully updated"
  #   click_on "Back"
  # end

  # test "destroying a User" do
  #   visit users_url
  #   page.accept_confirm do
  #     click_on "Destroy", match: :first
  #   end

  #   assert_text "User was successfully destroyed"
  # end
end
