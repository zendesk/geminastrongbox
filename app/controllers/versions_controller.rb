class VersionsController < ApplicationController
  include Helpers::Geminabox

  helper_method :link_to_gem, :reverse_dependencies, :load_gems

  def show
    # Taken from https://github.com/geminabox/geminabox/blob/0.12.4/lib/geminabox/server.rb#L108-L109
    gems = Hash[server_instance.send(:load_gems).by_name]
    @gem = gems[params['gemname']]
    @version = @gem && @gem.find { |g| g.number = params['version'] }

    unless @version
      render nothing: true, status: :not_found
      return
    end

    @spec = server_instance.send(:spec_for, @version.name, @version.number)
  end

  private

  # Allows us to use the instance methods defined in Geminabox::Server.
  #
  # We use .new! as defined by Sinatra so we get a class instance and not a
  # Sinatra::Wrapper instance.
  def self.server_instance

  end

  def server_instance
    @server_instance ||= Geminabox::Server.new!
  end

  def load_gems
    server_instance.send(:load_gems)
  end
end
