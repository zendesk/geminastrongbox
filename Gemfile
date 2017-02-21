source 'https://rubygems.org'

ruby File.read('.ruby-version').strip

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0'

# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'bcrypt'

gem 'geminabox', '>= 0.13.5'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
gem 'sinatra', '2.0.0.beta2'
gem 'bootstrap-sass'
gem 'font-awesome-sass'
gem 'unicorn-rails'
gem 'unicorn', '~> 4.8.3'
gem 'dotenv-rails'

group :sqlite do
  gem "sqlite3"
end

group :mysql2 do
  gem 'mysql2'
end

group :postgres do
  gem 'pg'
end

group :test do
  gem 'minitest-spec-rails'
  gem 'maxitest'
end

group :development do
  gem 'spring'
end

group :development, :test do
  gem 'byebug'
end
