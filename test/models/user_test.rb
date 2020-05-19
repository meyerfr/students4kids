require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'full_name returns the capitalized first name and last name' do
    user = users(:user_admin_users_model_full_name)
    assert_equal 'Full Name', user.full_name
  end

  test 'is_role(role) returns true if role == @user.role' do
    user = users(:user_admin_users_model_is_role)
    assert_equal true, user.is_role?('admin')
    assert_equal false, user.is_role?('sitter')
    assert_equal false, user.is_role?('parent')

    user = users(:user_sitter_users_model_is_role)
    assert_equal false, user.is_role?('admin')
    assert_equal true, user.is_role?('sitter')
    assert_equal false, user.is_role?('parent')

    user = users(:user_parent_users_model_is_role)
    assert_equal false, user.is_role?('admin')
    assert_equal false, user.is_role?('sitter')
    assert_equal true, user.is_role?('parent')
  end

  test "User should be valid because all attributes are present" do
    user = User.new(
        first_name: "Test",
        last_name: "Test",
        email: "test.test@code.berlin",
        role: "sitter",
        password: "testTest"
    )
    assert(user.valid?)
  end

  test "User should be invalid because first name is missing" do
    user = User.new(
        last_name: "Test",
        email: "test.test@code.berlin",
        role: "sitter",
        password: "testTest"
    )
    assert(user.invalid?)
  end

  test "User should be invalid because last name is missing" do
    user = User.new(
        first_name: "Test",
        email: "test.test@code.berlin",
        role: "sitter",
        password: "testTest"
    )
    assert(user.invalid?)
  end

  test "User should be invalid because email is missing" do
    user = User.new(
        first_name: "Test",
        last_name: "Test",
        role: "sitter",
        password: "testTest"
    )
    assert(user.invalid?)
  end

  test "User should be invalid because password is missing" do
    user = User.new(
        first_name: "Test",
        last_name: "Test",
        email: "test.test@code.berlin",
        role: "sitter"
    )
    assert(user.invalid?)
  end

  test "User should be valid because sitter is a valid role" do
    user = User.new(
        first_name: "Test",
        last_name: "Test",
        email: "test.test@code.berlin",
        role: "sitter",
        password: "testTest"
    )
    assert(user.valid?)
  end

  test "User should be valid because parent is a valid role" do
    user = User.new(
        first_name: "Test",
        last_name: "Test",
        email: "test.test@code.berlin",
        role: "parent",
        password: "testTest"
    )
    assert(user.valid?)
  end

  test "User should be valid because admin is a valid role" do
    user = User.new(
        first_name: "Test",
        last_name: "Test",
        email: "test.test@code.berlin",
        role: "admin",
        password: "testTest"
    )
    assert(user.valid?)
  end

  test "User should be valid because test is an invalid role" do
    user = User.new(
        first_name: "Test",
        last_name: "Test",
        email: "test.test@code.berlin",
        role: "test",
        password: "testTest"
    )
    assert(user.invalid?)
  end
end
