require 'spec_helper'

describe 'Signing out' do
  subject(:logout) { click_link 'Logout' }

  context 'when user is logged in', :auth do
    before do
      visit protected_page_path
      logout
    end

    it 'should sign out the user successfully' do
      expect(page).to have_content('Signed out successfully.')
    end

    it 'should redirect to the root path' do
      expect(current_path).to eq(root_path)
    end
  end

  context 'when user is not logged in' do
    # This test case models the scenario where someone presses
    # the browser back button after logging out
    before do
      visit root_path
      logout
    end

    it 'should not display a success message' do
      expect(page).to_not have_content('Signed out successfully.')
    end

    it 'should redirect to the root path' do
      expect(current_path).to eq(root_path)
    end
  end
end
