class SystemDevicesController < ApplicationController
  before_filter :require_admin!

  def index
  end

  def new
    @new_device = User.system_user.devices.new
  end

  def create
    @new_device = User.system_user.devices.build(params.require(:device).permit(:name))

    if !@new_device.save
      render :new
    end
  end

  def destroy
    User.system_user.devices.find(params[:id]).destroy
    redirect_to system_devices_path
  end
end
