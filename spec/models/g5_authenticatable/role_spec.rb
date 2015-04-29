require 'spec_helper'

describe G5Authenticatable::Role do
  subject { role }
  let(:role) { G5Authenticatable::Role.new(role_attributes) }
  let(:role_attributes) { FactoryGirl.attributes_for(:g5_authenticatable_role) }

  it { is_expected.to have_and_belong_to_many(:users) }
  it { is_expected.to belong_to(:resource) }

  it 'should expose the name attribute' do
    expect(role.name).to eq(role_attributes[:name])
  end
end
