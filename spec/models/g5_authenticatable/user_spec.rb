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

  describe '.new_with_session' do
    subject(:new_user) { G5Authenticatable::User.new_with_session(params, session) }

    let(:params) { Hash.new }
    let(:auth_data) do
      OmniAuth::AuthHash.new({
        'provider' => new_user_attributes[:provider],
        'uid' => new_user_attributes[:uid],
        'info' => {
          'email' => new_user_attributes[:email],
          'name' => "#{new_user_attributes[:first_name]} #{new_user_attributes[:last_name]}",
          'first_name' => new_user_attributes[:first_name],
          'last_name' => new_user_attributes[:last_name],
          'phone' => new_user_attributes[:phone_number]
        },
        'credentials' => {
          'token' => new_user_attributes[:g5_access_token],
          'expires' => true,
          'expires_at' => Time.now + 1000
        },
        'extra' => {
          'title' => new_user_attributes[:title],
          'organization_name' => new_user_attributes[:organization_name],
          'raw_info' => {}
        }
      })
    end
    let(:new_user_attributes) { FactoryGirl.attributes_for(:g5_authenticatable_user) }

    context 'when there is auth data in the session' do
      let(:session) { {'omniauth.auth' => auth_data} }

      it 'should initialize a new user' do
        expect(new_user).to be_a_new_record
      end

      it 'should not persist the user' do
        expect { new_user }.to_not change { G5Authenticatable::User.count }
      end

      it 'should set the provider from the session data' do
        expect(new_user.provider).to eq(new_user_attributes[:provider])
      end

      it 'should set the uid from the session data' do
        expect(new_user.uid).to eq(new_user_attributes[:uid])
      end

      it 'should set the email from the session data' do
        expect(new_user.email).to eq(new_user_attributes[:email])
      end

      it 'should set the first_name from the session data' do
        expect(new_user.first_name).to eq(new_user_attributes[:first_name])
      end

      it 'should set the last_name from the session data' do
        expect(new_user.last_name).to eq(new_user_attributes[:last_name])
      end

      it 'should set the phone_number from the session data' do
        expect(new_user.phone_number).to eq(new_user_attributes[:phone_number])
      end

      it 'should set the title from the session data' do
        expect(new_user.title).to eq(new_user_attributes[:title])
      end

      it 'should set the organization_name from the session data' do
        expect(new_user.organization_name).to eq(new_user_attributes[:organization_name])
      end
    end

    context 'when there is no auth data in the session' do
      let(:session) { Hash.new }

      it 'should initialize a new user' do
        expect(new_user).to be_a_new_record
      end

      it 'should not persist the user' do
        expect { new_user }.to_not change { G5Authenticatable::User.count }
      end

      it 'should not set the uid' do
        expect(new_user.uid).to be_nil
      end

      it 'should set the provider to the default value' do
        expect(new_user.provider).to eq('g5')
      end

      it 'should not set the email' do
        expect(new_user.email).to be_blank
      end
    end
  end
end
