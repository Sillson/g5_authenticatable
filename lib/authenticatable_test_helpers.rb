require 'g5_authenticatable/rspec'

module G5Authenticatable

  module TestHelpers

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
      visit path
    end

  end

end

shared_context "auth", :auth => true do

  include G5Authenticatable::TestHelpers

  let( :user ) { FactoryGirl.create( :g5_authenticatable_user ) }

  before do
    OmniAuth.config.test_mode = true
    stub_g5_omniauth(user)
  end

  after do
    OmniAuth.config.test_mode = false
  end

end

