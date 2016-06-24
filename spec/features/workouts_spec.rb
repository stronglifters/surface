require "rails_helper"

feature "Workouts", type: :feature do
  include_context "stronglifts_program"
  subject { WorkoutsPage.new }
  let(:user) { create(:user, password: "password") }
  let!(:workout) { create(:workout, user: user, routine: routine_a, occurred_at: DateTime.now, body_weight: 210.0) }

  before :each do
    subject.login_with(user.username, "password")
    subject.visit_page
  end

  describe "view training history" do
    it "displays each training session" do
      expect(page).to have_content(workout.occurred_at.strftime("%a, %d %b"))
    end
  end
end
