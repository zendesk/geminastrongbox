module Helpers::Geminabox
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers
    include ActionView::Helpers::CsrfHelper
  end

  def protect_against_forgery?
    false
  end

  def flash
    {}
  end

  def current_user
    return nil if session[:user_id].blank?
    @current_user = User.find(session[:user_id])
  end

  def method_missing(method_sym, *arguments, &block)
    if ActionController::Base.helpers.respond_to?(method_sym)
      ActionController::Base.helpers.send(method_sym, *arguments, &block)
    else
      super
    end
  end

  def partial_collection(template, collection)
    collection.map do |object|
      erb("_#{template}".to_sym, :layout => false, :locals => { template => object })
    end.join
  end

  def find_gem_by_name(name)
    gem_cache[name]
  end

  def link_to_gem(name)
    link = if find_gem_by_name(name)
      "#{geminabox_path}/gems/#{name}"
    else
      "https://rubygems.org/gems/#{name}"
    end

    link_to(name, link)
  end

  private

  def gem_cache
    @gem_cache ||= Hash[load_gems.by_name]
  end
end
