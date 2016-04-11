class TokensController < ApplicationController
  skip_before_filter :authenticate!, :verify_authenticity_token

  def show
    device = authenticate_with_http_basic{|identifier,password|
      Device.find_by_identifier(identifier).try(:authenticate, password)
    }

    render text: device.generate_token
  end
end

