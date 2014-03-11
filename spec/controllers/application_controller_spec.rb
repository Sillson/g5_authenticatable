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

  describe 'test helpers' do
    let(:response_value) { 'stuff' }

    controller do

      before_filter :authenticate_user!

      def index
        render text: 'stuff'
      end

    end

    context 'when there is an authenticated request', :auth_controller do

      it 'should be successful' do
        get :index
        expect(response.body).to eq(response_value)
      end

    end

    context 'when there is an unauthenticated request' do

      it 'should be unsuccesful' do
        get :index
        expect(response).to redirect_to('/g5_auth/users/sign_in')
      end

    end

  end
end
