class StatusController < ActionController::Base
  def status
    render text: 'ok'
  end
end
