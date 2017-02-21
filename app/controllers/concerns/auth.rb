module Auth
  extend ActiveSupport::Concern

  included do
    before_action :authenticate!
    helper_method :current_user
  end

  protected

  def current_user
    return nil if session[:user_id].blank?
    @current_user = User.where(:id => session[:user_id]).first
  end

  def authenticate!
    redirect_to(login_path(:origin => request.path)) unless current_user
  end

  def require_admin!
    head :forbidden unless current_user.is_admin?
  end

  def logout!(msg = "You have been logged out.")
    session.delete(:user_id)
    flash[:notice] = msg
    redirect_to(login_path(:origin => request.path))
    @current_user = nil
  end
end
