require 'spec_helper'

describe ApplicationPolicy do
  subject(:policy) { described_class }

  let(:user) { FactoryGirl.create(:g5_authenticatable_user) }
  let(:record) { FactoryGirl.create(:post) }

  permissions :index? do
    it 'denies access by default' do
      expect(policy).to_not permit(user, record)
    end
  end

  permissions :show? do
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

  permissions :create? do
    it 'denies access by default' do
      expect(policy).to_not permit(user, record)
    end
  end

  permissions :new? do
    it 'denies access by default' do
      expect(policy).to_not permit(user, record)
    end
  end

  permissions :update? do
    it 'denies access by default' do
      expect(policy).to_not permit(user, record)
    end
  end

  permissions :edit? do
    it 'denies access by default' do
      expect(policy).to_not permit(user, record)
    end
  end

  permissions :destroy? do
    it 'denies access by default' do
      expect(policy).to_not permit(user, record)
    end
  end

  describe '#scope' do
    subject(:scope) { policy.new(user, record).scope }

    it 'should look up the correct scope based on the record class' do
      post_scope = PostPolicy::Scope.new(user, record.class)
      expect(scope).to eq(post_scope.resolve)
    end
  end
end
