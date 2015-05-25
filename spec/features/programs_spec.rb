require "rails_helper"

feature "Programs", type: :feature do
  include_context "stronglifts_program"
  subject { ProgramPage.new(program) }
  let(:user) { create(:user, password: "password") }

  before :each do
    login_page = LoginPage.new
    login_page.visit_page
    login_page.login_with(user.username, "password")
    subject.visit_page
  end

  describe "view program" do
    it "displays the details of the program" do
      expect(page).to have_content(program.name)
    end
  end
end
