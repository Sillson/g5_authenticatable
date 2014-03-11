module G5Authenticatable
  module Test
    module ControllerHelpers

      def login_user(user)
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

      def logout_user(user)
        sign_out(user)
      end

    end
  end
end

shared_context 'auth controller', auth_controller: true do
  include G5Authenticatable::Test::ControllerHelpers
  let(:user) { FactoryGirl.create(:g5_authenticatable_user) }

  before { login_user(user) }
  after { logout_user(user) }
end

RSpec.configure do |config|
  config.include G5Authenticatable::Test::ControllerHelpers, type: :controller
end
