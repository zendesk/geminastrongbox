class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate!

  helper_method :current_user

  protected

  def current_user
    return nil if session[:user_id].blank?
    @current_user = User.find(session[:user_id])
  end

  def authenticate!
    redirect_to(login_path(:origin => request.path)) unless current_user
  end

  def logout!(msg = "You have been logged out.")
    session.delete(:user_id)
    flash[:notice] = msg
    redirect_to(login_path(:origin => request.path))
    @current_user = nil
  end
end
