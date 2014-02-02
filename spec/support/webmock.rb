require 'webmock/rspec'

RSpec.configure do |config|
  # We have to explicitly disable webmock to allow
  # the Code Climate test reporter to send coverage data
  config.after(:suite) { WebMock.disable! }
end
