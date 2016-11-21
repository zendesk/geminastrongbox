# frozen_string_literal: true
file = Rails.root.join('REVISION')

Rails.application.config.revision =
  ENV['HEROKU_SLUG_COMMIT'] || # heroku labs:enable runtime-dyno-metadata
  (File.exist?(file) && File.read(file).chomp) || # local file from docker builds
  `git rev-parse HEAD`.chomp.presence # local git
