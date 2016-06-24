require "rails_helper"

describe TrainingSessionsController do
  let(:user) { create(:user) }

  before :each do
    http_login(user)
  end

  describe "#index" do
    include_context "stronglifts_program"
    let!(:training_session_a) { create(:training_session, user: user, workout: workout_a) }
    let!(:training_session_b) { create(:training_session, user: user, workout: workout_b) }

    it "loads all my training sessions" do
      get :index
      expect(assigns(:training_sessions)).to match_array([training_session_a, training_session_b])
    end
  end

  describe "#new" do
    include_context "stronglifts_program"

    it "loads the next workout in the program" do
      create(:training_session, user: user, workout: workout_a)

      get :new

      expect(assigns(:workout)).to eql(workout_b)
    end

    it "loads the first workout in the program" do
      get :new

      expect(assigns(:workout)).to eql(workout_a)
    end
  end

  describe "#create" do
    include_context "stronglifts_program"
    let(:body_weight) { rand(250.0) }

    it "creates a new training session" do
      post :create, training_session: {
        workout_id: workout_b.id,
        body_weight: body_weight
      }
      expect(user.reload.training_sessions.count).to eql(1)
      expect(user.last_workout).to eql(workout_b)
      expect(user.training_sessions.last.body_weight).to eql(body_weight.to_f)
      expect(response).to redirect_to(edit_training_session_path(user.training_sessions.last))
    end

    it 'creates the training session with the selected exercises' do
      post :create, training_session: {
        workout_id: workout_b.id,
        body_weight: body_weight,
        exercise_sets_attributes: [{
          exercise_id: squat.id,
          target_repetitions: 5,
          target_weight: 200,
        }]
      }

      expect(user.reload.training_sessions.count).to eql(1)
      expect(user.last_workout).to eql(workout_b)
      training_session = user.training_sessions.last
      expect(training_session.body_weight).to eql(body_weight.to_f)
      expect(training_session.workout).to eql(workout_b)
      expect(training_session.exercise_sets.count).to eql(1)
      expect(response).to redirect_to(edit_training_session_path(user.training_sessions.last))
    end
  end

  describe "#edit" do
    let(:training_session) { create(:training_session, user: user) }

    it "loads the training session" do
      get :edit, id: training_session.id
      expect(assigns(:training_session)).to eql(training_session)
    end
  end
end
