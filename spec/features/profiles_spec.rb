require "rails_helper"

feature "Profiles", type: :feature do
  include_context "stronglifts_program"
  let(:user) { create(:user) }
  let(:user_session) { create(:active_session, user: user) }

  before :each do
    page.set_rack_session(user_id: user_session.id)
  end

  context "when the user has not completed any workouts" do
    subject { ProfilePage.new(user) }

    before { subject.visit_page }

    it "displays the users username" do
      expect(page).to have_content(user.username)
    end

    it "displays the number of workouts completed" do
      translations = I18n.translate("profiles.show.no_workouts_completed")
      expect(page).to have_content(translations)
    end
  end

  context "editing my profile" do
    subject { EditProfilePage.new(user) }

    before { subject.visit_page }

    it "allows me to edit my profile" do
      subject.change(gender: :male, social_tolerance: :low)
      subject.save_changes

      expect(page).to have_content(user.username)
      expect(page).to have_content(
        I18n.translate("profiles.edit.profile_update_success")
      )
    end

    it "allows me to choose my home gym", js: true do
      gym = build(:gym)
      allow(Gym).to receive(:create_from_yelp!).and_return(gym)

      VCR.use_cassette("home_gym") do
        subject.click_link(I18n.t("profiles.edit.choose_home_gym"))
        subject.choose_home_gym(city: "calgary", name: "sait")
        subject.save_changes

        expect(page).to have_content(gym.name)
      end
    end
  end
end
