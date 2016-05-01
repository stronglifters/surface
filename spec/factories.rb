FactoryGirl.define do
  factory :exercise do
    name { FFaker::Internet.user_name }
  end
  factory :program do
    name { FFaker::Internet.user_name }
  end
  factory :training_session do
    association :user
    association :workout
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
  factory :workout do
    association :program
    name { FFaker::Internet.user_name }
  end
  factory :email, class: OpenStruct do
    to [{
      full: "to_user@email.com",
      email: "to_user@email.com",
      token: "to_user",
      host: "email.com",
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
