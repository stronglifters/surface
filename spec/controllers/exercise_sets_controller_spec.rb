require "rails_helper"

describe ExerciseSetsController do
  let(:user) { create(:user) }

  before :each do
    http_login(user)
  end

  describe "#update" do
    include_context "stronglifts_program"
    let(:workout) { user.next_workout_for(routine_a) }

    it "records the exercise" do
      workout.update!(occurred_at: DateTime.now, body_weight: 225)
      exercise_set = workout.exercise_sets.first

      xhr :patch, :update, id: exercise_set.id, exercise_set: {
        actual_weight: 315,
        actual_repetitions: 5,
      }
      expect(response).to have_http_status(:ok)
      expect(exercise_set.reload.actual_repetitions).to eql(5)
    end
  end
end
