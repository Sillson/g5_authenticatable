require 'spec_helper'

describe 'Default role-based authorization API' do
  let(:json) { JSON.parse(response.body) }

  describe 'GET /posts', :auth_request do
    subject(:get_posts) { get posts_path, format: :json }

    let!(:post) { FactoryGirl.create(:post, author: user) }
    let!(:other_post) { FactoryGirl.create(:post) }

    context 'when user is a super_admin' do
      let(:user) { FactoryGirl.create(:g5_authenticatable_super_admin) }

      before { get_posts }

      it 'returns ok' do
        expect(response).to be_ok
      end

      it 'includes all posts' do
        expect(json).to contain_exactly(
          hash_including('id' => post.id,
                         'author_id' => post.author.id,
                         'content' => post.content),
          hash_including('id' => other_post.id,
                         'author_id' => other_post.author.id,
                         'content' => other_post.content)
        )
      end
    end

    context 'when user is not a super_admin' do
      before { get_posts }

      it 'returns forbidden' do
        expect(response).to be_forbidden
      end
    end
  end
end
