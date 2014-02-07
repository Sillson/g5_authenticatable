require 'spec_helper'

describe G5Authenticatable::User do
  subject { user }
  let(:user) { G5Authenticatable::User.create(user_attributes) }
  let(:user_attributes) { attributes_for(:g5_authenticatable_user) }

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

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_uniqueness_of(:uid).scoped_to(:provider) }

  it 'should support timeouts' do
    expect(user.timeout_in).to be > 0
  end
end
