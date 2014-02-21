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

  let(:user) { create(:g5_authenticatable_user) }

  before { login_user(user) }
  after { logout_user }
end

RSpec.configure do |config|
  config.include G5Authenticatable::Test::RequestHelpers, type: :request
  config.after { Warden.test_reset! }
end
