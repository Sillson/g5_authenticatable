require 'spec_helper'

describe 'OmniAuth' do
  describe 'routing' do
    it 'should route GET /users/auth/g5' do
      expect(get '/g5_auth/users/auth/g5').to be_routable
    end

    it 'should route GET /users/auth/g5/callback' do
      expect(get '/g5_auth/users/auth/g5/callback').to be_routable
    end
  end

  describe 'route helpers' do
    it 'should generate a user_g5_authorize_path' do
      expect(user_g5_authorize_path).to eq('/g5_auth/users/auth/g5')
    end

    it 'should generate a user_g5_callback_path' do
      expect(user_g5_callback_path).to eq('/g5_auth/users/auth/g5/callback')
    end
  end
end
