require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'full_name returns the capitalized first name and last name' do
    user = users(:schack)
    assert_equal 'Fritz Schack', user.full_name
  end

  test 'is_role(role) returns true if role == user.role' do
    user = users(:meyer)
    assert_equal true, user.is_role?('parent')
    assert_equal false, user.is_role?('sitter')
    assert_equal false, user.is_role?('admin')
  end
end
