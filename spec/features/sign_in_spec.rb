require 'spec_helper'

describe 'Signing in' do
  let(:user) { FactoryGirl.create(:g5_authenticatable_user) }

  context 'from a login link' do
    subject(:login) { click_link 'Login' }

    before { visit root_path }

    context 'when user exists locally' do
      before do
        stub_g5_omniauth(user)
        login
      end

      it 'should sign in the user successfully' do
        expect(page).to have_content('Signed in successfully.')
      end

      it 'should redirect the user to the root path' do
        expect(current_path).to eq(root_path)
      end
    end

    context 'when user does not exist locally' do
      before do
        OmniAuth.config.mock_auth[:g5] = OmniAuth::AuthHash.new({
          uid: uid,
          provider: 'g5',
          info: {email: 'new.test.user@test.host'},
          credentials: {token: g5_access_token},
          extra: {}
        })
      end

      let(:uid) { 42 }
      let(:g5_access_token) { 'my secret token string' }

      it 'should sign in the user successfully' do
        login
        expect(page).to have_content('Signed in successfully.')
      end

      it 'should redirect the user to the root path' do
        login
        expect(current_path).to eq(root_path)
      end

      it 'should create the user locally' do
        expect { login }.to change { G5Authenticatable::User.count }.by(1)
      end
    end
  end

  context 'when visiting a protected page' do
    before do
      visit_path_and_login_with(protected_page_path, user)
    end

    it 'should sign in the user successfully' do
      expect(page).to have_content('Signed in successfully.')
    end

    it 'should redirect the user to the protected page' do
      expect(current_path).to eq(protected_page_path)
    end
  end
end
