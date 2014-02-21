require 'g5_authenticatable/rspec'

RSpec.configure do |config|
  config.include G5Authenticatable::Test::RequestHelpers, type: :request
end
