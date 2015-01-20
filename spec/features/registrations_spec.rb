require "rails_helper"

feature "Registrations", type: :feature do
  subject { NewRegistrationPage.new }

  before :each do
    subject.visit_page
  end

  describe "creating a new account" do
    it 'registers a new account' do
      subject.register_with(username: 'mo', email: 'mo@example.com', password: 'password')

      expect(current_path).to eql(dashboard_path)
    end

    context "when the username is taken" do
      let!(:user) { create(:user) }

      it 'displays an error' do
        subject.register_with(username: user.username)

        expect(page).to have_content("Username has already been taken")
      end
    end

    context "when the email is taken" do
      let!(:user) { create(:user) }

      it 'displays an error' do
        subject.register_with(email: user.email)

        expect(page).to have_content("Email has already been taken")
      end
    end
  end
end
