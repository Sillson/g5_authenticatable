require 'spec_helper'

describe G5Authenticatable::User do
  subject { user }
  let(:user) { G5Authenticatable::User.create(user_attributes) }
  let(:user_attributes) { FactoryGirl.attributes_for(:g5_authenticatable_user) }

  it 'should expose the email' do
    expect(user.email).to eq(user_attributes[:email])
  end

  it 'should expose the user provider' do
    expect(user.provider).to eq(user_attributes[:provider])
  end

  it 'should expose the user uid' do
    expect(user.uid).to eq(user_attributes[:uid])
  end

  it 'should expose a g5_access_token' do
    expect(user.g5_access_token).to eq(user_attributes[:g5_access_token])
  end

  it 'should initialize the sign_in_count' do
    expect(user.sign_in_count).to eq(0)
  end

  it 'should expose a method for updating tracked attributes' do
    expect(user).to respond_to(:update_tracked_fields!)
  end

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:provider) }

  it 'should support timeouts' do
    expect(user.timeout_in).to be > 0
  end

  it 'should expose the first_name' do
    expect(user.first_name).to eq(user_attributes[:first_name])
  end

  it 'should expose the last_name' do
    expect(user.last_name).to eq(user_attributes[:last_name])
  end

  it 'should expose the phone number' do
    expect(user.phone_number).to eq(user_attributes[:phone_number])
  end

  it 'should expose the title' do
    expect(user.title).to eq(user_attributes[:title])
  end

  it 'should expose the organization name' do
    expect(user.organization_name).to eq(user_attributes[:organization_name])
  end
end
