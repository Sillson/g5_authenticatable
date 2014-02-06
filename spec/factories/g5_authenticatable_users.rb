# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :g5_authenticatable_user, :class => 'G5Authenticatable::User' do
    sequence(:email) { |n| "test.user#{n}@test.host" }
    provider 'g5'
    sequence(:uid) { |n| "abc123-#{n}" }
    sequence(:g5_access_token) { |n| "secret_token_#{n}" }
    password 'test_secret'
  end
end
