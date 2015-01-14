module G5Authenticatable
  module Test
    module FeatureHelpers
      def stub_g5_omniauth(user, options={})
        OmniAuth.config.mock_auth[:g5] = OmniAuth::AuthHash.new({
          uid: user.uid,
          provider: 'g5',
          info: {email: user.email},
          credentials: {token: user.g5_access_token}
        }.merge(options))
      end

      def stub_g5_invalid_credentials
        OmniAuth.config.mock_auth[:g5] = :invalid_credentials
      end

      def visit_path_and_login_with(path, user)
        stub_g5_omniauth(user)
        stub_valid_access_token(user.g5_access_token)
        visit path
      end
    end
  end
end

shared_context 'auth', auth: true do
  include G5Authenticatable::Test::FeatureHelpers

  let(:user) { FactoryGirl.create(:g5_authenticatable_user) }

  before { stub_g5_omniauth(user) }
end

RSpec.configure do |config|
  config.before(:each) { OmniAuth.config.test_mode = true }
  config.after(:each) { OmniAuth.config.test_mode = false }

  config.include G5Authenticatable::Test::FeatureHelpers, type: :feature
end
