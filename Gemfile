source 'https://rubygems.org'

ruby "2.2.2"
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use sqlite3 as the database for Active Record
group :production do
  gem 'pg'
  gem 'rails_12factor'
end

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# authentication using devise
gem 'devise'
# role management
gem 'cancancan', '~> 1.10'
# bootstrap sass & its dependencies
gem 'bootstrap-sass'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'autoprefixer-rails'
gem 'sprockets-rails'
gem 'sprockets'
#haml
gem 'haml'
#git API gem
gem "octokit", "~> 3.0"

gem 'puma'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'mysql2'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  #erb To Haml
  # run 'rake haml:replace_erbs' command
  gem 'erb2haml'
end

#Use angular js
gem 'angularjs-rails'
gem 'angular-ui-bootstrap-rails'

#csrf, write value of xsrf-token cookie into x-xsrf-token header
gem 'angular_rails_csrf'

#angular devise via assets
gem 'bower-rails'
gem 'angular-rails-templates'
gem 'responders', '~> 2.0'

source "https://rails-assets.org" do
  gem 'rails-assets-angular'
  gem 'rails-assets-angular-route'
  gem 'rails-assets-angular-resource'
  gem 'rails-assets-angular-devise'
  gem 'rails-assets-angular-ui-router'
  #gem 'rails-assets-angular-ui-bootstrap'
end

# Specify your gem's dependencies in tracker_api.gemspec
gemspec

