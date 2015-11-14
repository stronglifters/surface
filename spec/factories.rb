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
end
