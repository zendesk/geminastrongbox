class SessionsController < ApplicationController
  skip_before_filter :authenticate!, :verify_authenticity_token

  def new
  end

  def create
    logout!("You are not welcome here!") unless allowed_to_login

    user = User.update_or_create_by_auth(auth_hash)
    session[:user_id] = user.id
    redirect_to(env['omniauth.origin'] || '/')
  end

  def destroy
    logout!
  end

  protected

  def allowed_to_login
    return false if auth_hash.nil?

    if restricted_email_domain
      return auth_hashinfo.email.end_with?(restricted_email_domain)
    end

    return true
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  def restricted_email_domain
    ENV["GOOGLE_DOMAIN"]
  end
end
