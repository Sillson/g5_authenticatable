require 'spec_helper'

describe 'Signing in' do
  let(:user) { create(:user) }

  before { visit_path_and_login_with(new_user_session_path, user) }

  it 'should sign in the user successfully' do
    expect(page).to have_content('Signed in successfully.')
  end

  it 'should redirect the user to the root path' do
    expect(current_path).to eq(root_path)
  end
end
