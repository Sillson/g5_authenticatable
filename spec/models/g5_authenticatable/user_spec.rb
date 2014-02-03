require 'spec_helper'

describe G5Authenticatable::User do
  let(:user) { described_class.new }

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
end
