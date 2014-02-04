require 'spec_helper'

describe G5Authenticatable::User do
  subject { user }
  let(:user) { create(:g5_authenticatable_user) }

  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:provider) }
  it { should allow_mass_assignment_of(:uid) }

  it 'should expose a g5_access_token' do
    expect(user).to respond_to(:g5_access_token)
  end

  it 'should initialize the sign_in_count' do
    expect(user.sign_in_count).to eq(0)
  end

  it 'should expose a method for updating tracked attributes' do
    expect(user).to respond_to(:update_tracked_fields!)
  end

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should_not validate_presence_of(:password) }
  it { should validate_confirmation_of(:password) }
end
