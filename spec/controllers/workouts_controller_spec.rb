require "rails_helper"

describe WorkoutsController do
  let(:user) { create(:user) }

  before :each do
    http_login(user)
  end

  describe "#index" do
    include_context "stronglifts_program"
    let!(:workout_a) { create(:workout, user: user, routine: routine_a, occurred_at: 1.week.ago) }
    let!(:workout_b) { create(:workout, user: user, routine: routine_b, occurred_at: 1.day.ago) }

    it "loads all my workouts" do
      get :index
      expect(assigns(:workouts)).to match_array([workout_a, workout_b])
    end

    it "loads all works since a given time" do
      get :index, since: 2.days.to_i
      expect(assigns(:workouts)).to match_array([workout_b])
    end
  end

  describe "#new" do
    include_context "stronglifts_program"

    it "loads the next routine in the program" do
      create(:workout, user: user, routine: routine_a)

      get :new

      expect(assigns(:routine)).to eql(routine_b)
    end

    it "loads the first routine in the program" do
      get :new

      expect(assigns(:routine)).to eql(routine_a)
    end
  end

  describe "#create" do
    include_context "stronglifts_program"
    let(:body_weight) { rand(250.0).lbs }

    it "creates a new workout" do
      post :create, params: {
        workout: {
          routine_id: routine_b.id,
          body_weight: body_weight
        }
      }
      expect(user.reload.workouts.count).to eql(1)
      expect(user.last_routine).to eql(routine_b)
      expect(user.workouts.last.body_weight).to eql(body_weight)
      expect(response).to redirect_to(edit_workout_path(user.workouts.last))
    end

    it "creates the workout with the selected exercises" do
      post :create, params: {
        workout: {
          routine_id: routine_b.id,
          body_weight: body_weight,
          exercise_sets_attributes: [{
            exercise_id: squat.id,
            target_repetitions: 5,
            target_weight: 200,
            type: "WorkSet",
          }]
        }
      }

      expect(user.reload.workouts.count).to eql(1)
      expect(user.last_routine).to eql(routine_b)
      workout = user.workouts.last
      expect(workout.body_weight).to eql(body_weight)
      expect(workout.routine).to eql(routine_b)
      expect(workout.sets.count).to eql(1)
      expect(response).to redirect_to(edit_workout_path(user.workouts.last))
    end
  end

  describe "#edit" do
    let(:workout) { create(:workout, user: user) }

    it "loads the workouts" do
      get :edit, params: { id: workout.id }
      expect(assigns(:workout)).to eql(workout)
    end
  end
end
