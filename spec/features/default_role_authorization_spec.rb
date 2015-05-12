require 'spec_helper'

describe 'Default role-based authorization UI' do
  describe 'Posts index' do
    let(:visit_posts_index) { visit_path_and_login_with(posts_path, user) }

    let!(:post) { FactoryGirl.create(:post, author: user) }
    let!(:other_post) { FactoryGirl.create(:post) }

    before { visit_posts_index }

    context 'when authenticated user is a super admin' do
      let(:user) { FactoryGirl.create(:g5_authenticatable_super_admin) }

      it 'renders the posts index page' do
        expect(current_path).to eq(posts_path)
      end

      it 'shows the first post' do
        expect(page).to have_content(post.content)
      end

      it 'shows the second post' do
        expect(page).to have_content(other_post.content)
      end
    end

    context 'when authenticated user is not a super admin' do
      let(:user) { FactoryGirl.create(:g5_authenticatable_user) }

      it 'displays an error message' do
        expect(page).to have_content('Forbidden')
      end

      it 'does not show the first post' do
        expect(page).to_not have_content(post.content)
      end

      it 'does not show the second post' do
        expect(page).to_not have_content(other_post.content)
      end
    end
  end
end
