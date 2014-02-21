require 'g5_authenticatable/rspec'

RSpec.configure do |config|
  config.before(:each) { OmniAuth.config.test_mode = true }
  config.after(:each) { OmniAuth.config.test_mode = false }

  config.include G5Authenticatable::Test::FeatureHelpers, type: :feature
end
