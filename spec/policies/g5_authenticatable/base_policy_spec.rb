require 'spec_helper'

describe G5Authenticatable::BasePolicy do
  subject(:policy) { described_class }

  let(:user) { FactoryGirl.create(:g5_authenticatable_user) }
  let(:record) { FactoryGirl.create(:g5_authenticatable_user) }

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
      let(:record) { FactoryGirl.build(:g5_authenticatable_user) }

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
end
