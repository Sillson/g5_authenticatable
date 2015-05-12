shared_examples_for 'a super_admin authorizer' do
  context 'when user is not a super_admin' do
    let(:user) { FactoryGirl.create(:g5_authenticatable_user) }

    it 'denies access by default' do
      expect(policy).to_not permit(user, record)
    end
  end

  context 'when user has super_admin role' do
    let(:user) { FactoryGirl.create(:g5_authenticatable_super_admin) }

    it 'permits access' do
      expect(policy).to permit(user, record)
    end
  end
end