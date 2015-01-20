require "rails_helper"

feature "Registrations", type: :feature do
  describe "creating a new account" do
    it 'registers a new account' do
      visit root_path
      click_link "Register"
      within "#new_user" do
        fill_in "Username", with: 'mo'
        fill_in "Email", with: 'mo@example.com'
        fill_in "Password", with: 'password'
        check "I Agree"
        click_button "Register"
      end

      expect(current_path).to eql(dashboard_path)
    end

    context "when the username is taken" do
      let!(:user) { User.create!(username: 'mo', email: 'mo@example.com', terms_and_conditions: true) }

      it 'displays an error' do
        visit root_path
        click_link "Register"
        within "#new_user" do
          fill_in "Username", with: user.username
          fill_in "Email", with: user.email
          fill_in "Password", with: 'password'
          check "I Agree"
          click_button "Register"
        end

        expect(page).to have_content("Username has already been taken")
        expect(page).to have_content("Email has already been taken")
      end
    end
  end
end
