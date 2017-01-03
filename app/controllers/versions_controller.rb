class VersionsController < ApplicationController
  helper Helpers::Geminabox
  helper_method :load_gems

  def show
    @version = server_instance.find_gem_by_name(params['gemname']).detect do |v|
      v.number.to_s == params['version']
    end

    unless @version
      head :not_found
      return
    end

    @spec = server_instance.send(:spec_for, @version.name, @version.number)
  end

  private

  # Allows us to use the instance methods defined in Geminabox::Server.
  #
  # We use .new! as defined by Sinatra so we get a class instance and not a
  # Sinatra::Wrapper instance.
  def server_instance
    @server_instance ||= Geminabox::Server.new!
  end

  def load_gems
    server_instance.send(:load_gems)
  end
end
