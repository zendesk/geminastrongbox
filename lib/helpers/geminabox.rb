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
      # both rails and sinatra are using this helper, so we need to check how to
      # evaluate the template
      if respond_to? :erb
        erb :"_#{template}", layout: false, locals: { template => object }
      else
        render "gems/#{template}", template => object
      end
    end.join.html_safe
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

  def link_to_author(author, email, default)
    url = email ? "mailto:#{email}" : default
    "<a href='#{url}'>#{author}</a>"
  end

  def reverse_dependencies(version)
    dependents = []

    load_gems.by_name do |name, versions|
      next if version.name == name

      latest_spec = spec_for(name, versions.newest.number)
      dependencies = latest_spec.dependencies

      dependent = dependencies.detect do |d|
        d.name == version.name && d.requirement.satisfied_by?(version.number)
      end

      if dependent
        dependent = dependent.dup
        dependent.name = name
        dependents << dependent
      end
    end

    dependents
  end

  private

  def gem_cache
    @gem_cache ||= Hash[load_gems.by_name]
  end
end
