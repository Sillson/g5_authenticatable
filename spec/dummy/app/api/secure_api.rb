class SecureApi < Grape::API
  helpers G5AuthenticatableApi::GrapeHelpers
  before { authenticate_user! }

  get 'secure_resource' do
    {hello: 'world'}
  end
end
