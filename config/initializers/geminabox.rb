require "geminabox"

Geminabox.data = ENV['DATA_PATH'] || Rails.root + (Rails.env.test? ? 'test/data' : 'data')
Geminabox.views = Rails.root + 'app/views/gems'
# Geminabox.rubygems_proxy = true

ssl_and_auth = -> {
  if !request.ssl? && !Rails.env.test?
    redirect url.sub('http://', 'https://')
  end

  if request.session[:user_id]
    current_user = User.find(request.session[:user_id])
    Rails.logger.info("Gem access granted to #{current_user.email}")
  else
    auth = Rack::Auth::Basic::Request.new(request.env)

    if auth.provided? && auth.basic? && auth.credentials
      identifier, password = auth.credentials
      device = Device.find_by_identifier(identifier).try(:authenticate, password)
    end

    if device.try(:user)
      device.used!
      Rails.logger.info("Gem access granted to #{device.user.email} on #{device.name}")
      current_user = device.user
    end
  end

  unless current_user
    response['WWW-Authenticate'] = %(Basic realm="gems")
    halt 401
  end
}

Geminabox::Server.before(&ssl_and_auth)
Geminabox::Hostess.before(&ssl_and_auth)
Geminabox::Proxy::Hostess.before(&ssl_and_auth)
Geminabox::Server.helpers Helpers::Geminabox
