source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'

# Database stuff
gem "pg"
gem 'composite_primary_keys'
gem "squeel"
gem 'aasm'
# Automatically creates validations basing on the database schema.
gem "schema_validations"

# Configuration
gem "dotenv-rails"

# Admin stuff
gem "rails_admin"

# GUI
gem 'simple_form'
gem 'rails-i18n'
gem 'devise-i18n'

# JS
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Jobs
gem 'sidekiq'
gem 'sinatra', :require => nil

# GIS
gem 'geokit-rails'
gem 'gmaps-autocomplete-rails'

# auth stuff
gem 'devise'
gem "cancancan"

# Dev stuff
group :development do
  gem 'quiet_assets'
  gem 'railroady'
end

# Mail
gem 'mailgun_rails'

# Logging
gem 'le'

group :production do
  gem 'rails_serve_static_assets'
end


group :development, :test do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

gem 'pry'              # Better IRB
gem 'pry-doc'

# Server
gem 'puma'             # Faster Server

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
