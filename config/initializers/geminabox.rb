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

bundler_version = -> {
  version = request.user_agent.to_s[%r{bundler/v([\d\.]+)}, 1]

  if version && Gem::Version.new(version) < Gem::Version.new('1.6.5')
    Rails.logger.info("Blocking bundler version #{version}")
    halt 403
    body 'You must use a version of bundler > 1.6.4.'
  end
}

[Geminabox::Server, Geminabox::Hostess, Geminabox::Proxy::Hostess].each do |klass|
  klass.before(&ssl_and_auth)
  klass.before(&bundler_version)
end

Geminabox::Server.helpers(Helpers::Geminabox)
