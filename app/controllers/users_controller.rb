class UsersController < ApplicationController
  before_filter :require_admin!

  def index
    @users = User.not_system_user.order('updated_at DESC')
  end

  def make_admin
    change_is_admin(true)
  end

  def make_non_admin
    if_safe_to_remove_admin do
      change_is_admin(false)
    end
  end

  def destroy
    if_safe_to_remove_admin do
      user.destroy
      redirect_to users_path
    end
  end

  protected

  def user
    @user = User.not_system_user.find(params[:id])
  end

  def change_is_admin(is_admin)
    user.update_attributes!(:is_admin => is_admin)
    redirect_to users_path
  end

  def if_safe_to_remove_admin
    if User.admin.count <= 1
      flash[:error] = 'That would leave system without any admins!'
      redirect_to users_path
    else
      yield
    end
  end
end
