require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'full_name returns the capitalized first name and last name' do
    user = users(:one)
    assert_equal 'John Lennon', user.full_name
  end
end
