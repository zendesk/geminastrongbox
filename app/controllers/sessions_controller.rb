class SessionsController < ApplicationController
  skip_before_filter :authenticate!, :verify_authenticity_token

  def new
  end

  def create
    return logout!("You are not welcome here!") unless allowed_to_login

    user = User.update_or_create_by_auth(auth_hash)
    session[:user_id] = user.id
    redirect_to(env['omniauth.origin'] || '/')
  end

  def destroy
    logout!
  end

  protected

  def allowed_to_login
    return false unless auth_hash

    restricted_email_domain.blank? ||
      auth_hash.info.email.end_with?(restricted_email_domain)
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  def restricted_email_domain
    ENV["GOOGLE_DOMAIN"]
  end
end
