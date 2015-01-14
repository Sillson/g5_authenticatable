require 'spec_helper'

describe 'UI Token validation' do
  let!(:old_auth_endpoint) { ENV['G5_AUTH_ENDPOINT'] }
  before { ENV['G5_AUTH_ENDPOINT'] = auth_endpoint }
  after { ENV['G5_AUTH_ENDPOINT'] = old_auth_endpoint }
  let(:auth_endpoint) { 'https://auth.test.host' }

  let(:user) { FactoryGirl.create(:g5_authenticatable_user) }

  before do
    stub_g5_omniauth(user)
    visit protected_page_path

    # Now that we're logged in, any subsequent attempts to
    # authenticate with the auth server will trigger an omniauth
    # failure, which is a condition we can test for
    stub_g5_invalid_credentials
  end

  context 'when token validation is enabled' do
    before { G5Authenticatable.strict_token_validation = true }

    context 'when user has a valid g5 access token' do
      before { stub_valid_access_token(user.g5_access_token) }

      it 'should allow the user to visit a protected page' do
        visit protected_page_path
        expect(current_path).to eq(protected_page_path)
      end
    end

    context 'when user has an invalid g5 access token' do
      before { stub_invalid_access_token(user.g5_access_token) }

      it 'should force the user to re-authenticate' do
        visit protected_page_path
        expect(current_path).to_not eq(protected_page_path)
      end
    end
  end

  context 'when token validation is disabled' do
    before { G5Authenticatable.strict_token_validation = false }

    it 'should allow the user to visit a protected page' do
      visit protected_page_path
      expect(current_path).to eq(protected_page_path)
    end
  end
end
