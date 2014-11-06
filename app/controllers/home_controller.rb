class HomeController < ApplicationController
  def show
    if current_user.devices.empty?
      redirect_to(devices_path)
    else
      redirect_to(geminabox_path)
    end
  end
  def status
    render text: 'ok'
  end
end
