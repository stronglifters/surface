FactoryGirl.define do
  factory :exercise do
    name { FFaker::Internet.user_name }
  end
  factory :exercise_set do
    association :exercise
    association :workout
    target_repetitions { rand(12) }
    target_weight { rand(400) }
    factory :work_set, class: "WorkSet"
  end
  factory :program do
    name { FFaker::Internet.user_name }
  end
  factory :workout do
    association :user
    association :routine
    occurred_at { DateTime.now }
    body_weight { rand(250) }
  end
  factory :user do
    username { FFaker::Internet.user_name }
    email { FFaker::Internet.email }
    password "password"
    password_confirmation "password"
    terms_and_conditions "1"
  end
  factory :routine do
    association :program
    name { FFaker::Internet.user_name }
  end
  factory :email, class: OpenStruct do
    to [{
      full: "cf9b756e-789d-4bbb-aee7-2c8298bb69a7@stronglifters.com",
      email: "cf9b756e-789d-4bbb-aee7-2c8298bb69a7@stronglifters.com",
      token: "cf9b756e-789d-4bbb-aee7-2c8298bb69a7",
      host: "stronglifters.com",
      name: nil
    }]
    from({
      token: "from_user",
      host: "email.com",
      email: "from_email@email.com",
      full: "From User <from_user@email.com>",
      name: "From User"
    })
    subject "email subject"
    body "Hello!"
    attachments { [] }

    trait :with_attachment do
      attachments {[
        ActionDispatch::Http::UploadedFile.new({
          filename: "spreadsheet-stronglifts.csv",
          type: "text/plain",
          tempfile: File.new(
            "#{File.expand_path(File.dirname(__FILE__))}/fixtures/spreadsheet-stronglifts.csv"
          )
        })
      ]}
    end
  end
  factory :gym do
    name { FFaker::Internet.user_name }
    association :location
    factory :calgary_gym do
      location { create(:calgary) }
    end
    factory :edmonton_gym do
      location { create(:edmonton) }
    end
    factory :portland_gym do
      location { create(:portland) }
    end
  end

  factory :user_session, class: UserSession do
    association :user
    ip FFaker::Internet.ip_v4_address
    factory :active_session do
      accessed_at Time.current
    end
  end

  factory :location do
    latitude { rand(90.0) }
    longitude { rand(180.0) }
    address { FFaker::Address.street_address }
    city { FFaker::AddressCA.city }
    region { FFaker::AddressCA.province }
    postal_code { FFaker::AddressCA.postal_code }
    country { FFaker::Address.country }
    factory :calgary do
      latitude { 51.0130333 }
      longitude { -114.2142365 }
      city { "Calgary" }
      region { "AB" }
      country { "CA" }
    end
    factory :edmonton do
      latitude { 53.5557956 }
      longitude { -113.6340292 }
      city { "Edmonton" }
      region { "AB" }
      country { "CA" }
    end
    factory :portland do
      latitude { 45.542415 }
      longitude { -122.7244614 }
      city { "Portland" }
      region { "OR" }
      country { "US" }
    end
    factory :no_where do
      latitude { 0.0 }
      longitude { 0.0 }
      city { "" }
      region { "" }
      country { "" }
      postal_code { "" }
    end
  end
end
