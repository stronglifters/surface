require "rails_helper"

feature "Profiles", type: :feature do
  include_context "stronglifts_program"

  subject { ProfilePage.new(user) }
  let(:user) { create(:user) }

  before :each do
    subject.visit_page
  end

  context "when the user has not completed any workouts" do
    it "displays the users username" do
      expect(page).to have_content(user.username)
    end

    it "displays the number of workouts completed" do
      expect(page).to have_content(I18n.translate("profiles.show.no_workouts_completed"))
    end
  end
end
