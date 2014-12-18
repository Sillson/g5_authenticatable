source 'https://rubygems.org'

# Declare your gem's dependencies in g5_authenticatable.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# TODO: remove this when the next version of devise_g5_authenticatable is released
gem 'devise_g5_authenticatable', git: 'git@github.com:G5/devise_g5_authenticatable', branch: 'sign_out_fixes'

# Gems used by the dummy application
gem 'rails', '4.1.4'
gem 'jquery-rails'
gem 'pg'
gem 'grape'

group :test, :development do
  gem 'rspec-rails', '~> 2.99'
  gem 'pry'
  gem 'dotenv-rails'
end

group :test do
  gem 'capybara'
  gem 'factory_girl_rails', '~> 4.3', require: false
  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter', require: false
  gem 'webmock'
  gem 'shoulda-matchers', '~> 2.6'
  gem 'generator_spec'
  gem 'rspec-http', require: 'rspec/http'
end

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'
