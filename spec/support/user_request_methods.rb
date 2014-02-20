require 'rspec/core/shared_context'

module UserRequestMethods
  extend RSpec::Core::SharedContext

  include Warden::Test::Helpers
  after { Warden.test_reset! }

  let(:user) { create(:g5_authenticatable_user) }

  def login_user
    login_as(user, scope: :user)
  end

  def logout_user
    logout :user
  end
end

RSpec.configure do |config|
  config.include UserRequestMethods, type: :request
end
