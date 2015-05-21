require 'spec_helper'

describe G5Authenticatable::Strategies::TokenAuthenticatable do
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
      before { stub_valid_auth_user(access_token, auth_user.to_hash) }

      let(:auth_user) do
        FactoryGirl.build_stubbed(:g5_auth_user, id: user.uid)
      end

      context 'when user already exists' do
        before do
          allow(G5Authenticatable::User).to receive(:find_by_provider_and_uid).
            and_return(user)
        end

        before { strategy._run! }

        it 'looks up the user' do
          expect(G5Authenticatable::User).
            to have_received(:find_by_provider_and_uid).with('g5', user.uid)
        end

        it 'sets the user' do
          expect(strategy.user).to eq(user)
        end

        it 'sets the action as success' do
          expect(strategy.result).to eq(:success)
        end
      end

      context 'when user does not exist' do
        before do
          allow(G5Authenticatable::User).to receive(:find_by_provider_and_uid).
            and_return(nil)
        end

        it 'creates the user'
        it 'sets the user'
        it 'sets the action as success'
      end
    end

    context 'when access_token is invalid' do
      before { stub_invalid_auth_user(access_token) }

      before { strategy._run! }

      it 'does not set the user' do
        expect(strategy.user).to be_nil
      end

      it 'sets the action as failure' do
        expect(strategy.result).to eq(:failure)
      end
    end
  end

  context 'when there is an authorization header' do
    before { env['HTTP_AUTHORIZATION'] = "Bearer #{access_token}" }
    let(:user) { FactoryGirl.build_stubbed(:g5_authenticatable_user) }
    let(:access_token) { user.g5_access_token }

    let(:auth_user) { FactoryGirl.build_stubbed(:g5_auth_user, id: user.uid) }
    before { stub_valid_auth_user(access_token, auth_user.to_hash) }

    before do
      allow(G5Authenticatable::User).to receive(:find_by_provider_and_uid).
        and_return(user)
    end
    let(:user) { FactoryGirl.build_stubbed(:g5_authenticatable_user) }

    before { strategy._run!}

    it 'looks up the user based on the token' do
      expect(G5Authenticatable::User).
        to have_received(:find_by_provider_and_uid).with('g5', user.uid)
    end

    it 'sets the user' do
      expect(strategy.user).to eq(user)
    end

    it 'sets the action as success' do
      expect(strategy.result).to eq(:success)
    end
  end

  context 'when there is no access_token on the request' do
    before { strategy._run! }

    it 'does not set the user' do
      expect(strategy.user).to be_nil
    end

    it 'sets the action as failure' do
      expect(strategy.result).to eq(:failure)
    end
  end
end
