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
