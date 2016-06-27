require "rails_helper"

feature "Workouts", type: :feature do
  let(:user) { create(:user, password: "password") }
  before :each do
    subject.login_with(user.username, "password")
  end

  feature "viewing history" do
    include_context "stronglifts_program"
    subject { WorkoutsPage.new }
    let!(:workout) { create(:workout, user: user, routine: routine_a, occurred_at: DateTime.now, body_weight: 210.0) }

    it "displays each training session" do
      subject.visit_page
      expect(page).to have_content(workout.occurred_at.strftime("%a, %d %b"))
    end
  end

  feature "starting a new workout" do
    include_context "stronglifts_program"
    subject { NewWorkoutPage.new }

    it 'creates a new workout' do
      subject.visit_page
      subject.change_body_weight(225.0)
      subject.click_start

      expect(user.workouts.count).to eql(1)
    end

  end
end
