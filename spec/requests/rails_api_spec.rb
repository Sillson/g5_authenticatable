require 'spec_helper'

describe 'a secure Rails API' do
  describe 'POST request to an API-only action' do
    subject(:api_call) { post '/rails/secure_resource' }

    context 'with an authenticated user', :auth_request do
      it 'should be successful' do
        api_call
        expect(response).to be_http_ok
      end
    end

    context 'without an authenticated user' do
      it 'should be unauthorized' do
        api_call
        expect(response).to be_http_unauthorized
      end
    end
  end

  describe 'GET json request to mixed type action' do
    subject(:api_call) { get '/rails/secure_resource.json' }

    context 'with an authenticated user', :auth_request do
      it 'should be successful' do
        api_call
        expect(response).to be_http_ok
      end
    end

    context 'without an authenticated user' do
      it 'should be unauthorized' do
        api_call
        expect(response).to be_http_unauthorized
      end
    end
  end

  describe 'GET html request to mixed type action' do
    subject(:website_call) { get '/rails/secure_resource.html' }

    it 'should be a redirect' do
      website_call
      expect(resposne).to be_redirect
    end

    it 'should redirect to the new session path' do
      website_call
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
