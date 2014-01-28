source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use mysql as the database for Active Record
group :development do
  gem 'mysql2'
end

group :production, :staging do
  gem 'pg'
  gem 'redis-rails'
  gem "unicorn"
end


group :test do
  gem 'sqlite3'
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

gem 'friendly_id', '~> 5.0.0'
gem "babosa"

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'devise', '3.2.2'
gem 'meta-tags', '1.5.0', require: 'meta_tags'

gem "rmagick"
gem "carrierwave"
gem "carrierwave-meta"

gem "settingslogic"

gem 'anjlab-bootstrap-rails', '~> 3.0.3.0', :require => 'bootstrap-rails'
gem "simple_form", "~> 3.0.0.rc"
gem "will_paginate", "3.0.3"

gem "high_voltage"

gem "rvm-capistrano"

gem "omniauth"
gem "omniauth-facebook"
gem "koala", "~> 1.8.0rc1"

gem "hipchat"

# Cache
gem "dalli"

gem "compass-rails"

gem "geocoder"
gem "active_link_to"

gem "font-awesome-rails", "~> 4.0.0"

gem 'rails-i18n', '~> 4.0.0' # For 4.0.x

gem "figaro"

gem 'activerecord-reputation-system', :github => 'NARKOZ/activerecord-reputation-system', :branch => 'rails4'

gem 'will_paginate-bootstrap'

gem 'grape'
gem 'grape-entity'
gem 'grape-swagger'
gem 'swagger-ui', :require => 'swagger'

gem "sitemap_generator"

gem 'airbrake'

group :development do
  gem "capistrano"
  gem "capistrano-ext"
  gem "cape"
  gem "binding_of_caller"
  gem "better_errors", "~> 0.9.0"
  gem "magic_encoding"
  gem "annotate"
  gem "powder"
  gem "pry-nav"
  gem "pry-remote"
  gem "meta_request"
  gem 'capistrano-unicorn', :require => false
end

group :test, :development do
  gem "rspec-rails"
  gem "database_cleaner"
  gem "shoulda-matchers"
  gem "fabrication"
  gem "faker"
  gem "timecop"
end



# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'


gem "active_model_serializers"

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end


