RSpec.configure do |config|
  config.around(:each) do |example|
    orig_auth_endpoint = ENV['G5_AUTH_ENDPOINT']
    ENV['G5_AUTH_ENDPOINT'] = 'https://test.auth.host'
    example.run
    ENV['G5_AUTH_ENDPOINT'] = orig_auth_endpoint
  end
end
