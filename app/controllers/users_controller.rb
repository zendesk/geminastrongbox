class UsersController < ApplicationController
  before_action :require_admin!

  def index
    @users = User.not_system_user.order('updated_at DESC')
  end

  def make_admin
    change_is_admin(true)
  end

  def make_non_admin
    change_is_admin(false)
  end

  def destroy
    if !user.destroy
      flash[:error] = user.errors.full_messages.join('. ')
    end

    redirect_to users_path
  end

  protected

  def user
    @user ||= User.not_system_user.find(params[:id])
  end

  def change_is_admin(is_admin)
    if !user.update_attributes(:is_admin => is_admin)
      flash[:error] = user.errors.full_messages.join('. ')
    end
    redirect_to users_path
  end
end
