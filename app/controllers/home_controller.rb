class HomeController < ApplicationController
  def show
    redirect_to(devices_path) if current_user.devices.empty?
  end
end
