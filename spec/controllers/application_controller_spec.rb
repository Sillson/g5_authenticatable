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
end
