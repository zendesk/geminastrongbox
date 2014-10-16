class DevicesController < ApplicationController
  def index
    if current_user.devices.empty?
      @new_device = current_user.devices.new
      render :initial
    end
  end

  def new
    @new_device = current_user.devices.new
  end

  def create
    @new_device = current_user.devices.build(params.require(:device).permit(:name))

    if !@new_device.save
      render :new
    end
  end

  def destroy
    current_user.devices.find(params[:id]).destroy
    redirect_to devices_path
  end
end
