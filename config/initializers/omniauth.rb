require 'omniauth'

OmniAuth.config.logger = Rails.logger

require 'omniauth-google-oauth2'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development? || Rails.env.test?

  provider :google_oauth2,
    ENV["GOOGLE_CLIENT_ID"],
    ENV["GOOGLE_CLIENT_SECRET"], {
      :name => "google",
      :scope => "email,profile",
      :prompt => "select_account"
    }
end
