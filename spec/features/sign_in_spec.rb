require 'spec_helper'

describe 'Signing in' do
  let(:user) { create(:g5_authenticatable_user) }

  context 'from a login link' do
    before do
      visit root_path
      stub_g5_omniauth(user)
      click_link 'Login'
    end

    it 'should sign in the user successfully' do
      expect(page).to have_content('Signed in successfully.')
    end

    it 'should redirect the user to the root path' do
      expect(current_path).to eq(root_path)
    end
  end
end
