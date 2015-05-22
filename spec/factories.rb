FactoryGirl.define do
  factory :exercise do
    name { FFaker::Internet.user_name }
  end
  factory :program do
    name { FFaker::Internet.user_name }
  end
  factory :training_session do
    association :user
    occurred_at { DateTime.now }
  end
  factory :user do
    username { FFaker::Internet.user_name }
    email { FFaker::Internet.email }
    password "password"
    password_confirmation "password"
    terms_and_conditions "1"
  end
  factory :workout do
    association :program
    name { FFaker::Internet.user_name }
  end
end
