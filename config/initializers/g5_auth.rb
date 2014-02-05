G5AuthenticationClient.configure do |defaults|
  defaults.client_id = ENV['G5_AUTH_CLIENT_ID']
  defaults.client_secret = ENV['G5_AUTH_CLIENT_SECRET']
  defaults.redirect_uri = ENV['G5_AUTH_REDIRECT_URI']
  defaults.endpoint = ENV['G5_AUTH_ENDPOINT']
end
