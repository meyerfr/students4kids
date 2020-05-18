require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:lennon)
  end

  test 'user signin' do
    visit root_url
    click_on "Login"
    assert_selector 'h2', text: 'Log in'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: "johnLennon"
    click_on 'Log in'
    assert_text "Signed in successfully."
  end

  test 'user sign out' do
    sign_in(@user)

    visit root_url
    click_on "Log out"

    assert_current_path(root_path)
    assert_text "Signed out successfully."
  end

  test 'user registration' do
    visit root_url
    click_on "signup_sitter"

    fill_in 'First name', with: "End_to_End Test"
    fill_in 'Last name', with: "End_to_End Test"
    fill_in 'Email', with: "end.to.end@test.com"
    fill_in 'user_password', with: "test1234"
    fill_in 'user_password_confirmation', with: "test1234"
    click_on 'Sign up'

    assert_text "Welcome! You have signed up successfully."
  end

  test 'show account' do
    sign_in(@user)

    visit root_url
    click_on "Account"

    assert_current_path(user_path(@user))
  end

  test 'edit account' do
    sign_in(@user)

    visit root_url
    click_on "Account"

    assert_current_path(user_path(@user))
    click_on "Edit"
    assert_current_path(edit_user_path(@user))
    # click_on "Submit changes"
    # assert_text "User was successfully updated."
  end

=begin
  test 'reset password' do
    visit root_url
    click_on "Login"
    click_on "Forgot your password?"
    fill_in "Email", with: @user.email
    click_on "Send me reset password instructions"
    assert_test "You will receive an email with instructions on how to reset your password in a few minutes."
  end
=end
end
