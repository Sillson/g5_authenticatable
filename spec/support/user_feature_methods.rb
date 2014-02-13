require 'authenticatable_test_helpers'

RSpec.configure do |config|
  config.before(:each) { OmniAuth.config.test_mode = true }
  config.after(:each) { OmniAuth.config.test_mode = false }

  config.include G5Authenticatable::TestHelpers, type: :feature
end
