ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  include Devise::Test::IntegrationHelpers
  include Warden::Test::Helpers
  # Add more helper methods to be used by all tests here...

  # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Log in user.
  def log_in(user)
    if integration_test?
      login_as(user, :scope => :user)
    else
      sign_in(user)
    end
  end
end

# class ActionDispatch::IntegrationTest

#   # Log in as a particular user.
#   def log_in_as(user, password: 'password', remember_me: '1')
#     post user_session_path, params: { session: { email: user.email,
#                                           password: password,
#                                           remember_me: remember_me } }
#   end
# end
