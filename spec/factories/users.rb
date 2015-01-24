FactoryGirl.define do
  factory :user do
    username Faker::Internet.user_name
    email Faker::Internet.email
    password "password"
    password_confirmation "password"
    terms_and_conditions "1"
  end
end
