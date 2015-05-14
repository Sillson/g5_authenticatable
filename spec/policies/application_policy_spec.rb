require 'spec_helper'

describe ApplicationPolicy do
  subject(:policy) { described_class }

  let(:user) { FactoryGirl.create(:g5_authenticatable_user) }
  let(:record) { FactoryGirl.create(:post) }

  permissions :index? do
    it_behaves_like 'a super_admin authorizer'
  end

  permissions :show? do
    context 'when user is a super_admin' do
      let(:user) { FactoryGirl.create(:g5_authenticatable_super_admin) }

      context 'when record exists in scope' do
        it 'permits access' do
          expect(policy).to permit(user, record)
        end
      end

      context 'when record does not exist in scope' do
        let(:record) { FactoryGirl.build(:post) }

        it 'denies access' do
          expect(policy).to_not permit(user, record)
        end
      end
    end

    context 'when user is not a super_admin' do
      it 'denies access' do
        expect(policy).to_not permit(user, record)
      end
    end
  end

  permissions :create? do
    it_behaves_like 'a super_admin authorizer'
  end

  permissions :new? do
    it_behaves_like 'a super_admin authorizer'
  end

  permissions :update? do
    it_behaves_like 'a super_admin authorizer'
  end

  permissions :edit? do
    it_behaves_like 'a super_admin authorizer'
  end

  permissions :destroy? do
    it_behaves_like 'a super_admin authorizer'
  end

  describe '#scope' do
    subject(:scope) { policy.new(user, record).scope }

    it 'should look up the correct scope based on the record class' do
      post_scope = PostPolicy::Scope.new(user, record.class)
      expect(scope).to eq(post_scope.resolve)
    end
  end

  describe '#super_admin?' do
    subject(:super_admin?) { policy.new(user, record).super_admin? }

    context 'when there is no user' do
      let(:user) {}

      it 'is false' do
        expect(super_admin?).to eq(false)
      end
    end

    context 'when user does not have super_admin role' do
      it 'is false' do
        expect(super_admin?).to eq(false)
      end
    end

    context 'when user has the super_admin role' do
      let(:user) { FactoryGirl.create(:g5_authenticatable_super_admin) }

      it 'is true' do
        expect(super_admin?).to eq(true)
      end
    end
  end

  describe '#admin?' do
    subject(:admin?) { policy.new(user, record).admin? }

    context 'when there is no user' do
      let(:user) {}

      it 'is false' do
        expect(admin?).to eq(false)
      end
    end

    context 'when user does not have admin role' do
      it 'is false' do
        expect(admin?).to eq(false)
      end
    end

    context 'when user has the admin role' do
      let(:user) { FactoryGirl.create(:g5_authenticatable_admin) }

      it 'is true' do
        expect(admin?).to eq(true)
      end
    end
  end

  describe '#editor?' do
    subject(:editor?) { policy.new(user, record).editor? }

    context 'when there is no user' do
      let(:user) {}

      it 'is false' do
        expect(editor?).to eq(false)
      end
    end

    context 'when user does not have editor role' do
      it 'is false' do
        expect(editor?).to eq(false)
      end
    end

    context 'when user has the editor role' do
      let(:user) { FactoryGirl.create(:g5_authenticatable_editor) }

      it 'is true' do
        expect(editor?).to eq(true)
      end
    end
  end

  describe '#viewer?' do
    subject(:viewer?) { policy.new(user, record).viewer? }

    context 'when there is no user' do
      let(:user) {}

      it 'is false' do
        expect(viewer?).to eq(false)
      end
    end

    context 'when user does not have viewer role' do
      let(:user) { FactoryGirl.create(:g5_authenticatable_editor) }

      it 'is false' do
        expect(viewer?).to eq(false)
      end
    end

    context 'when user has the viewer role' do
      it 'is true' do
        expect(viewer?).to eq(true)
      end
    end
  end
end
