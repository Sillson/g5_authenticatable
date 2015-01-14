RSpec.configure do |config|
  config.before(:each) { G5Authenticatable.strict_token_validation = false }
end
