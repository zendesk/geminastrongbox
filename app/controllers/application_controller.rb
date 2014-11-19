class ApplicationController < ActionController::Base
  include Auth
  protect_from_forgery with: :exception
  force_ssl unless Rails.env.test?
end
