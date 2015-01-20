FactoryGirl.define do
  factory :user do
    username Faker::Internet.user_name
    email Faker::Internet.email
    terms_and_conditions true
  end
end
