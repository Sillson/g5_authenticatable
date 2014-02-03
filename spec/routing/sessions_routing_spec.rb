require 'spec_helper'

describe 'SessionsController' do
  describe 'routing' do
    it 'should route GET /users/sign_in' do
      expect(get '/g5_auth/users/sign_in').to be_routable
    end

    it 'should route DELETE /users/sign_out' do
      expect(delete '/g5_auth/users/sign_out').to be_routable
    end
  end

  describe 'route helpers' do
    it 'should generate a new_user_session_path' do
      expect(new_user_session_path).to eq('/g5_auth/users/sign_in')
    end

    it 'should generate a destroy_user_session_path' do
      expect(destroy_user_session_path).to eq('/g5_auth/users/sign_out')
    end
  end
end
