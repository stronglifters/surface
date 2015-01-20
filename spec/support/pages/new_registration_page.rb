require_relative '../page_model.rb'

class NewRegistrationPage < PageModel
  def initialize
    super(new_registration_path)
  end

  def register_with(username: Faker::Internet.user_name,
                    email: Faker::Internet.email,
                    password: 'password',
                    terms: true)
    within "#new_user" do
      fill_in "Username", with: username
      fill_in "Email", with: email
      fill_in "Password", with: password
      check "I Agree"
      click_button "Register"
    end
  end
end
