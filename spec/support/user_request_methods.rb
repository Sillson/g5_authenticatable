require 'g5_authenticatable/rspec'

RSpec.configure do |config|
  config.include G5Authenticatable::Test::RequestHelpers, type: :request
  config.after { Warden.test_reset! }
end
