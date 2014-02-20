require 'spec_helper'

describe 'a secure Grape API' do
  subject(:api_call) { get '/api/secure_resource' }

  context 'with an authenticated user' do
    before { login_user }

    it 'should be successful' do
      api_call
      expect(response).to be_http_ok
    end
  end

  context 'without an authenticated user' do
    before { logout_user }

    it 'should be unauthorized' do
      api_call
      expect(response).to be_http_unauthorized
    end
  end
end
