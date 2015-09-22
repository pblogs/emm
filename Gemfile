source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
gem 'pg'
gem 'dotenv-rails'

gem 'rails-api'
gem 'active_model_serializers'

gem 'angular-rails-templates'
gem 'spa_rails', github: 'Rezonans/spa_rails'

gem 'jwt_authentication', github: 'Rezonans/jwt_authentication'
gem 'cancancan', '~> 1.10'
gem 'devise'

gem 'uglifier'
gem 'autoprefixer-rails'

gem 'carrierwave'
gem 'mini_magick'

gem 'mandrill_mailer'
gem 'launchy'

# fixtures replacement with a straightforward definition syntax
gem 'factory_girl_rails'
# populating database with real-looking test data
gem 'faker'
# a set of strategies for cleaning your database
gem 'database_cleaner'

gem 'kaminari'

source 'https://rails-assets.org' do
  # General libs
  gem 'rails-assets-lodash'
  # Angular and extensions
  gem 'rails-assets-angular'
  gem 'rails-assets-ui-utils'
  gem 'rails-assets-ui-router'
  gem 'rails-assets-angular-permission'
  gem 'rails-assets-restangular', '1.5.1'
  gem 'rails-assets-satellizer', '0.9.4'
  # Styling and components
  gem 'rails-assets-angular-bootstrap'
  gem 'rails-assets-bootstrap'
  gem 'rails-assets-font-awesome', '~>4.3.0'
  gem 'rails-assets-animate.css'
  gem 'rails-assets-angular-animate'
  gem 'rails-assets-angular-loading-bar'
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'quiet_assets'
  gem 'guard-livereload', '~> 2.4', require: false
  gem 'capistrano',  '~> 3.1'
  # Allow assets manifest backup with folder "manifests" (https://github.com/capistrano/rails/pull/92)
  # bundle exec cap deploy !
  gem 'capistrano-rails', github: 'capistrano/rails'
  gem 'capistrano3-unicorn'
  gem 'capistrano-rvm'
end

group :production do
  gem 'unicorn'
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'rspec-rails'
  gem 'json_spec'
end
