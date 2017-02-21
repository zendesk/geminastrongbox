# frozen_string_literal: true
if key = ENV['AIRBRAKE_API_KEY']
  Airbrake.user_information = # replaces <!-- AIRBRAKE ERROR --> on 500 pages
    "<br/><br/>Error number: <a href='https://airbrake.io/locate/{{error_id}}'>{{error_id}}</a>"

  Airbrake.configure do |config|
    config.project_id = ENV.fetch('AIRBRAKE_PROJECT_ID')
    config.project_key = key

    config.blacklist_keys = Rails.application.config.filter_parameters

    # send correct errors even when something blows up during initialization
    config.environment = Rails.env
    config.ignore_environments = [:test, :development]

    # report in development:
    # - add AIRBRAKE_API_KEY to ENV
    # - add AIRBRAKE_PROJECT_ID to ENV
    # - set consider_all_requests_local = false in development.rb
    # - uncomment
    # config.ignore_environments = [:test]
  end
end
