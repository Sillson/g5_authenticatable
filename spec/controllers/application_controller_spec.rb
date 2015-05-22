require 'spec_helper'

describe ::ApplicationController do
  it 'should have the correct new_session_path for users' do
    expect(controller.new_session_path(:user)).to eq('/g5_auth/users/sign_in')
  end

  it 'should have the correct destroy_session_path for users' do
    expect(controller.destroy_session_path(:user)).to eq('/g5_auth/users/sign_out')
  end

  it 'should have the correct g5_authorize_path for users' do
    expect(controller.g5_authorize_path(:user)).to eq('/g5_auth/users/auth/g5')
  end

  it 'should have the correct g5_callback_path for users' do
    expect(controller.g5_callback_path(:user)).to eq('/g5_auth/users/auth/g5/callback')
  end

  context 'when strict token validation is enabled' do
    before { G5Authenticatable.strict_token_validation = true }

    it_should_behave_like 'a secure controller'
  end

  context 'when strict token validation is disabled' do
    before { G5Authenticatable.strict_token_validation = false }

    it_should_behave_like 'a secure controller'
  end

  it 'should mixin pundit authorization' do
    expect(controller).to respond_to(:authorize)
  end

  it 'should mixin pundit scoping' do
    expect(controller).to respond_to(:policy_scope)
  end

  it 'should mixin authorization error handling' do
    expect(controller).to respond_to(:user_not_authorized)
  end

  describe '#current_user' do
    subject(:current_user) { controller.current_user }

    context 'when already authenticated through warden', :auth_controller do
      it 'is the user from warden' do
        expect(current_user).to eq(user)
      end
    end

    context 'when authenticated with a token' do
      let(:auth_user) { FactoryGirl.build_stubbed(:g5_auth_user, id: user.uid) }
      before { stub_valid_auth_user(token_value, auth_user)}
      let(:token_value) { user.g5_access_token }

      context 'in the request params' do
        before { request.params[:access_token] = token_value }

        context 'when the user exists locally' do
          let(:user) { FactoryGirl.create(:g5_authenticatable_user) }

          it 'is the user that owns the token' do
            expect(current_user).to eq(user)
          end
        end

        context 'when the user does not exist locally' do
          let(:user) { FactoryGirl.build_stubbed(:g5_authenticatable_user) }

          it 'creates the user locally' do
            current_user
            local_user = G5Authenticatable::User.find_by_provider_and_uid(user.provider, user.uid)
            expect(current_user).to eq(local_user)
          end
        end
      end

      context 'in the request headers' do
        let(:user) { FactoryGirl.create(:g5_authenticatable_user) }

        it 'is the local user that owns the token' do
          expect(current_user).to eq(user)
        end
      end
    end
  end
end
