require 'factory_girl_rails'

FactoryGirl.define do
  factory :g5_authenticatable_user, class: 'G5Authenticatable::User' do
    sequence(:email) { |n| "test.user#{n}@test.host" }
    provider 'g5'
    sequence(:uid) { |n| "abc123-#{n}" }
    sequence(:g5_access_token) { |n| "secret_token_#{n}" }
    first_name 'Jane'
    last_name 'Doe'
    phone_number '(555) 867-5309'
    title 'Minister of Funny Walks'
    organization_name 'Department of Redundancy Department'

    after(:build) do |user|
      user.roles << FactoryGirl.build(:g5_authenticatable_viewer_role)
    end
  end

  factory :g5_authenticatable_super_admin, parent: :g5_authenticatable_user do
    after(:build) do |user|
      user.roles.clear
      user.roles << FactoryGirl.build(:g5_authenticatable_super_admin_role)
    end
  end

  factory :g5_authenticatable_admin, parent: :g5_authenticatable_user do
    after(:build) do |user|
      user.roles.clear
      user.roles << FactoryGirl.build(:g5_authenticatable_admin_role)
    end
  end

  factory :g5_authenticatable_editor, parent: :g5_authenticatable_user do
    after(:build) do |user|
      user.roles.clear
      user.roles << FactoryGirl.build(:g5_authenticatable_editor_role)
    end
  end

  factory :g5_authenticatable_role, class: 'G5Authenticatable::Role' do
    sequence(:name) { |n| "role_#{n}" }
  end

  factory :g5_authenticatable_super_admin_role, parent: :g5_authenticatable_role do
    name 'super_admin'
  end

  factory :g5_authenticatable_admin_role, parent: :g5_authenticatable_role do
    name 'admin'
  end

  factory :g5_authenticatable_editor_role, parent: :g5_authenticatable_role do
    name 'editor'
  end

  factory :g5_authenticatable_viewer_role, parent: :g5_authenticatable_role do
    name 'viewer'
  end

  factory :g5_auth_user, class: 'G5AuthenticationClient::User' do
    sequence(:id) { |n| n.to_s }
    first_name 'Test'
    sequence(:last_name) { |n| "User #{n}"}
    phone_number '(555) 555-5555'
    title 'Tester'
    organization_name 'QA'

    after(:build) do |user|
      user.roles << G5AuthenticationClient::Role.new(name: 'admin')
    end
  end
end
