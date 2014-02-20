require 'factory_girl_rails'

FactoryGirl.define do
  factory :g5_authenticatable_user, :class => 'G5Authenticatable::User' do
    sequence(:email) { |n| "test.user#{n}@test.host" }
    provider 'g5'
    sequence(:uid) { |n| "abc123-#{n}" }
    sequence(:g5_access_token) { |n| "secret_token_#{n}" }
  end
end
