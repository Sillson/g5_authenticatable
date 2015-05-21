require 'spec_helper'

describe G5Authenticatable::Strategies::TokenAuthenticatable do
  before do
    Warden::Strategies.clear!
    Warden::Strategies.add(:g5_token_authenticatable, described_class)
  end

  let(:strategy) do
    Warden::Strategies[:g5_token_authenticatable].new(env_with_params)
  end

  let(:env_with_params) do
    Rack::MockRequest.env_for("/?#{Rack::Utils.build_query(params)}", env)
  end
  let(:params) { Hash.new }
  let(:env) do
    {
      'HTTP_VERSION' => '1.1',
      'REQUEST_METHOD' => 'GET'
    }
  end

  context 'when there is an access_token param' do
    before { params['access_token'] = access_token }

    let(:user) { FactoryGirl.build_stubbed(:g5_authenticatable_user) }
    let(:access_token) { user.g5_access_token }

    context 'when access_token is valid' do
      before { stub_valid_access_token(access_token) }

      let(:auth_user) { FactoryGirl.build_stubbed(:g5_auth_user, id: user.uid) }
      before { stub_auth_user_request(access_token, auth_user.to_hash) }

      context 'when user already exists' do
        before do
          allow(User).to receive(:find_by_provider_and_uid).and_return(user)
        end

        it 'looks up the user'
        it 'sets the user'
        it 'sets the action as success'
      end

      context 'when user does not exist' do
        before do
          allow(User).to receive(:find_by_provider_and_uid).and_return(nil)
        end

        it 'creates the user'
        it 'sets the user'
        it 'sets the action as success'
      end
    end

    context 'when access_token is invalid' do
      before { stub_invalid_access_token(access_token) }

      it 'does not set the user'
      it 'sets the action as failure'
    end
  end

  context 'when there is an authorization header' do
    before { env['HTTP_AUTHORIZATION'] = "Bearer #{access_token}" }
    let(:user) { FactoryGirl.build_stubbed(:g5_authenticatable_user) }
    let(:access_token) { user.g5_access_token }

    let(:auth_user) { FactoryGirl.build_stubbed(:g5_auth_user, id: user.uid) }
    before { stub_auth_user_request(access_token, auth_user.to_hash) }

    it 'looks up the user based on the token in the header'
    it 'sets the user'
    it 'sets the action as success'
  end

  context 'when there is no access_token on the request' do
    it 'does not set the user'
    it 'sets the action as failure'
  end
end
