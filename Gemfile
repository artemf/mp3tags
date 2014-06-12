source 'https://rubygems.org'
ruby '2.1.1'

gem 'rails', '4.1.0'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'

gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'ruby-mp3info'

gem 'pg'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
gem 'rack-timeout'
gem 'unicorn'


# Support Heroku
group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'spring'
  gem 'rspec-rails', '~> 2.14.0'
  gem 'factory_girl_rails', '~> 4.2.1', :require => false
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'
end

