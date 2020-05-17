require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'full_name returns the capitalized first name and last name' do
    @user = users(:schack)
    assert_equal 'Fritz Schack', @user.full_name
  end

  test 'is_role(role) returns true if role == @user.role' do
    @user = users(:admin)
    assert @user.is_role?('admin'), "Should return true, as #{@user.full_name} (id: #{@user.id}), has the role #{@user.role}."
    @user = users(:schack)
    assert @user.is_role?('sitter'), "Should return true, as #{@user.full_name} (id: #{@user.id}), has the role #{@user.role}."
    @user = users(:meyer)
    assert @user.is_role?('parent'), "Should return true, as #{@user.full_name} (id: #{@user.id}), has the role #{@user.role}."
  end

  test "User should be valid because all attributes are present" do
    @user = User.new(
        first_name: "Test",
        last_name: "Test",
        email: "test.test@code.berlin",
        role: "sitter",
        password: "testTest"
    )
    assert(@user.valid?)
  end

  test "User should be invalid because first name is missing" do
    @user = User.new(
        last_name: "Test",
        email: "test.test@code.berlin",
        role: "sitter",
        password: "testTest"
    )
    assert(@user.invalid?)
  end

  test "User should be invalid because last name is missing" do
    @user = User.new(
        first_name: "Test",
        email: "test.test@code.berlin",
        role: "sitter",
        password: "testTest"
    )
    assert(@user.invalid?)
  end

  test "User should be invalid because email is missing" do
    @user = User.new(
        first_name: "Test",
        last_name: "Test",
        role: "sitter",
        password: "testTest"
    )
    assert(@user.invalid?)
  end

  test "User should be invalid because password is missing" do
    @user = User.new(
        first_name: "Test",
        last_name: "Test",
        email: "test.test@code.berlin",
        role: "sitter"
    )
    assert(@user.invalid?)
  end

  test "User should be valid because sitter is a valid role" do
    @user = User.new(
        first_name: "Test",
        last_name: "Test",
        email: "test.test@code.berlin",
        role: "sitter",
        password: "testTest"
    )
    assert(@user.valid?)
  end

  test "User should be valid because parent is a valid role" do
    @user = User.new(
        first_name: "Test",
        last_name: "Test",
        email: "test.test@code.berlin",
        role: "parent",
        password: "testTest"
    )
    assert(@user.valid?)
  end

  test "User should be valid because admin is a valid role" do
    @user = User.new(
        first_name: "Test",
        last_name: "Test",
        email: "test.test@code.berlin",
        role: "admin",
        password: "testTest"
    )
    assert(@user.valid?)
  end

  test "User should be valid because test is an invalid role" do
    @user = User.new(
        first_name: "Test",
        last_name: "Test",
        email: "test.test@code.berlin",
        role: "test",
        password: "testTest"
    )
    assert(@user.invalid?)
  end
end
