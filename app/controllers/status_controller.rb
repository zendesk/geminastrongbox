class StatusController < ActionController::Base
  protect_from_forgery with: :exception

  def status
    render text: 'ok'
  end
end
