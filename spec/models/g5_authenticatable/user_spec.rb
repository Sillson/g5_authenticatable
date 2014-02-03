require 'spec_helper'

describe G5Authenticatable::User do
  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:provider) }
  it { should allow_mass_assignment_of(:uid) }

  it 'should expose a g5_access_token' do
    expect(described_class.new).to respond_to(:g5_access_token)
  end
end
