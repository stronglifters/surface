require "rails_helper"

feature "Workouts", type: :feature do
  let(:user) { create(:user, password: "password") }
  before :each do
    subject.login_with(user.username, "password")
  end

  feature "viewing history" do
    include_context "stronglifts_program"
    subject { WorkoutsPage.new }
    let!(:workout) do
      create(:workout,
             user: user,
             routine: routine_a,
             occurred_at: DateTime.now,
             body_weight: 210.0
            )
    end

    it "displays each training session" do
      subject.visit_page
      expect(page).to have_content(workout.occurred_at.strftime("%a, %d %b"))
    end
  end

  feature "starting a new workout" do
    include_context "stronglifts_program"
    subject { NewWorkoutPage.new }

    it "creates a new workout" do
      subject.visit_page
      subject.change_body_weight(225.0)
      subject.click_start

      expect(user.workouts.count).to eql(1)
      expect(user.workouts.last.body_weight).to eql(225.0)
    end
  end

  feature "recording a workout", js: true do
    include_context "stronglifts_program"

    subject { EditWorkoutPage.new(workout) }

    let!(:workout) do
      squat_workout
      bench_workout
      row_workout
      dips_workout
      workout = user.next_workout_for(routine_a)
      workout.update!(occurred_at: DateTime.now, body_weight: 225)
      workout
    end

    before :each do
      subject.visit_page
      subject.open_section(squat)
    end

    it "saves the successful set" do
      first_squat_set = workout.sets.for(squat).at(0)
      subject.complete(set: first_squat_set)
      expect(first_squat_set.reload.actual_repetitions).to eql(5)
    end

    it "saves the failed set" do
      second_squat_set = workout.sets.for(squat).at(1)
      subject.complete(set: second_squat_set, repetitions: 4)
      expect(second_squat_set.reload.actual_repetitions).to eql(4)
    end

    it "does not change an incomplete set" do
      third_squat_set = workout.sets.for(squat).at(2)
      expect(third_squat_set.reload.actual_repetitions).to be_nil
    end
  end
end
