require "geminabox"

Geminabox.data = ENV['DATAPATH'] || 'data'
Geminabox.views = Rails.root + 'app/views/gems'
# Geminabox.rubygems_proxy = true

auth = -> {
  auth = Rack::Auth::Basic::Request.new(request.env)

  if request.session[:user_id]
    current_user = User.find(request.session[:user_id])
    Rails.logger.info("Gem access granted to logged in user #{current_user.email}")
  else
    if auth.provided? && auth.basic? && auth.credentials
      identifier, password = auth.credentials
      device = Device.find_by_identifier(identifier).try(:authenticate, password)
    end

    if device && device.user
      device.used!
      Rails.logger.info("Gem access granted to user #{device.user.email} on device #{device.id}")
      current_user = device.user
    end
  end

  unless current_user
    response['WWW-Authenticate'] = %(Basic realm="gems")
    halt 401
  end
}

Geminabox::Server.before(&auth)
Geminabox::Hostess.before(&auth)
Geminabox::Proxy::Hostess.before(&auth)

Geminabox::Server.helpers do
  include ActionView::Helpers::CsrfHelper

  def protect_against_forgery?
    false
  end

  def current_user
    return nil if session[:user_id].blank?
    @current_user = User.find(session[:user_id])
  end

  def method_missing(method_sym, *arguments, &block)
    if ActionController::Base.helpers.respond_to?(method_sym)
      ActionController::Base.helpers.send(method_sym, *arguments, &block)
    else
      super
    end
  end
end
