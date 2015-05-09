FactoryGirl.define do
  factory :post do
    content 'This is my post'
    association :author, factory: :g5_authenticatable_user
  end
end
