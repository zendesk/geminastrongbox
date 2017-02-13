class ApplicationController < ActionController::Base
  include Auth
  protect_from_forgery with: :exception
  force_ssl unless Rails.env.test? || Rails.env.development? || ENV['SKIP_FORCE_SSL']
end
