class ApplicationController < ActionController::Base
  include Auth
  protect_from_forgery with: :exception
end
