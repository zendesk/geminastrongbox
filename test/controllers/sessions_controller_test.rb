require_relative '../test_helper'
require 'minitest/mock'

class SessionsControllerTest < ActionController::TestCase
  describe 'create' do
    describe 'when not allowed to login' do
      it 'does not log the user in' do
        @controller.stub(:restricted_email_domain, 'example.com') do
          request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
            :info => { :email => 'test@example.org' }
          )

          post :create, params: {:provider => 'google'}

          assert_access_denied
        end
      end
    end

    describe 'when allowed to login' do
      it 'allows email through without email domain restriction' do
        @controller.stub(:restricted_email_domain, '') do
          request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
            :info => { :email => 'test@example.org' }
          )

          post :create, params: {:provider => 'google'}
          assert_not_nil session[:user_id]
          assert_redirected_to '/'
        end
      end

      it 'allows email through with email domain restriction' do
        @controller.stub(:restricted_email_domain, 'example.org') do
          request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
            :info => { :email => 'test@example.org' }
          )

          post :create, params: {:provider => 'google'}
          assert_not_nil session[:user_id]
          assert_redirected_to '/'
        end
      end
    end
  end
end
