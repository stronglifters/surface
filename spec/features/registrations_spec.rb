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
  end
end
