require 'spec_helper'

describe G5Authenticatable::ApplicationHelper do
  describe '#current_user' do
    subject(:current_user) { helper.current_user }

    before { helper.request.env['warden'] = warden }
    let(:warden) { double(:warden) }

    let(:user) { FactoryGirl.build_stubbed(:g5_authenticatable_user) }

    context 'when already authenticated through warden' do
      before do
        allow(warden).to receive(:authenticate).with(scope: :user).and_return(user)
      end

      it 'is the user from warden' do
        expect(current_user).to eq(user)
      end
    end

    context 'when authenticated with a token' do
      before { stub_valid_auth_user(token_value, auth_user)}
      let(:token_value) { user.g5_access_token }
      let(:auth_user) { FactoryGirl.build_stubbed(:g5_auth_user, id: user.uid) }

      before { allow(warden).to receive(:authenticate).and_return(nil) }

      context 'in the request params' do
        before { helper.request.params[:access_token] = token_value }

        context 'when the user exists locally' do
          before do
            allow(G5Authenticatable::User).to receive(:find_by_provider_and_uid).
              with(user.provider, user.uid).and_return(user)
          end

          it 'updates the local user'
          it 'returns the local user' do
            expect(current_user).to eq(user)
          end
        end

        context 'when the user does not exist locally' do
          it 'creates the local user'
          it 'returns the local user'
        end
      end

      context 'in the request headers' do
        before { helper.request.headers['Authorization'] = "Bearer #{token_value}" }

        before do
          allow(G5Authenticatable::User).to receive(:find_by_provider_and_uid).
            with(user.provider, user.uid).and_return(user)
        end

        it 'updates the local user'

        it 'returns the local user' do
          expect(current_user).to eq(user)
        end
      end
    end
  end
end
