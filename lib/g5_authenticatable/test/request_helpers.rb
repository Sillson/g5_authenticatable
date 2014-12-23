module G5Authenticatable
  module Test
    module RequestHelpers
      include Warden::Test::Helpers

      def login_user(user)
        login_as(user, scope: :user)
      end

      def logout_user
        logout :user
      end

      def stub_valid_access_token(token_value)
        stub_request(:get, "#{ENV['G5_AUTH_ENDPOINT']}/oauth/token/info").
          with(headers: {'Authorization'=>"Bearer #{token_value}"}).
          to_return(status: 200, body: '', headers: {})
      end

      def stub_invalid_access_token(token_value)
        stub_request(:get, "#{ENV['G5_AUTH_ENDPOINT']}/oauth/token/info").
          with(headers: {'Authorization'=>"Bearer #{token_value}"}).
          to_return(status: 401,
                    headers: {'Content-Type' => 'application/json; charset=utf-8',
                              'Cache-Control' => 'no-cache'},
                    body: {'error' => 'invalid_token',
                           'error_description' => 'The access token expired'}.to_json)
      end
    end
  end
end

shared_context 'auth request', auth_request: true do
  include G5Authenticatable::Test::RequestHelpers

  let(:user) { FactoryGirl.create(:g5_authenticatable_user) }

  let!(:orig_auth_endpoint) { ENV['G5_AUTH_ENDPOINT'] }
  let(:auth_endpoint) { 'https://test.auth.host' }
  before { ENV['G5_AUTH_ENDPOINT'] = auth_endpoint }
  after { ENV['G5_AUTH_ENDPOINT'] = orig_auth_endpoint }

  before do
    login_user(user)
    stub_valid_access_token(user.g5_access_token)
  end

  after { logout_user }
end

RSpec.configure do |config|
  config.include G5Authenticatable::Test::RequestHelpers, type: :request
  config.after { Warden.test_reset! }
end
