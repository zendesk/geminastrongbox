ENV['RAILS_ENV'] = 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'maxitest/autorun'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  def self.when_logged_in_as(*user_identifiers, &block)
    Array.wrap(user_identifiers).each do |user_identifier|
      msg = user_identifier ? "when logged in as #{user_identifier}" : 'when not logged in'

      describe msg do
        let(:current_user) { user_identifier ? users(user_identifier) : nil }

        before { session[:user_id] = current_user.try(:id) }

        class_eval(&block)
      end
    end
  end

  def self.when_not_logged_in(&block)
    when_logged_in_as(nil, &block)
  end

  def assert_access_denied
    assert_redirected_to login_path(:origin => request.path)
  end
end

class ActionDispatch::IntegrationTest
  def self.when_logged_in_as(*user_identifiers, &block)
    Array.wrap(user_identifiers).each do |device_identifier|
      msg = device_identifier ? "when logged in as #{device_identifier}" : 'when not logged in'

      describe msg do
        let(:current_device) { device_identifier ? devices(device_identifier) : nil }
        let(:current_user) { current_device.try(:user) }
        let(:env) do
          if current_user
            {
              'HTTP_AUTHORIZATION' => "Basic " + Base64::encode64("#{current_device.identifier}:123456")
            }
          else
            {}
          end
        end

        class_eval(&block)
      end
    end
  end

  def self.when_not_logged_in(&block)
    when_logged_in_as(nil, &block)
  end
end
