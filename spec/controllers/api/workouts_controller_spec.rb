require "rails_helper"

describe Api::WorkoutsController do
  render_views
  let(:user) { create(:user) }

  before :each do
    api_login(user)
  end

  describe "#index" do
    it "returns each workout" do
      workout = create(:workout, user: user)

      get :index, format: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:workouts].count).to eql(1)
    end
  end

  describe "#new" do
    include_context "stronglifts_program"

    it 'loads the next workout' do
      get :new, format: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:body_weight]).to eql({ amount: 0.0, unit: 'lbs' })
      expect(json[:routine]).to eql({ id: routine_a.id, name: routine_a.name })
      expect(json[:exercises]).to match_array([
        { id: barbell_row.id, name: barbell_row.name },
        { id: bench_press.id, name: bench_press.name, },
        { id: squat.id, name: squat.name, },
      ])
      expect(json[:sets]).to match_array([
        { id: nil, exercise_id: squat.id, type: 'WorkSet', target_weight: 45.lbs.to_h, target_repetitions: 5, actual_repetitions: nil, target_duration: nil, actual_duration: nil },
        { id: nil, exercise_id: squat.id, type: 'WorkSet', target_weight: 45.lbs.to_h, target_repetitions: 5, actual_repetitions: nil, target_duration: nil, actual_duration: nil },
        { id: nil, exercise_id: squat.id, type: 'WorkSet', target_weight: 45.lbs.to_h, target_repetitions: 5, actual_repetitions: nil, target_duration: nil, actual_duration: nil },
        { id: nil, exercise_id: squat.id, type: 'WorkSet', target_weight: 45.lbs.to_h, target_repetitions: 5, actual_repetitions: nil, target_duration: nil, actual_duration: nil },
        { id: nil, exercise_id: squat.id, type: 'WorkSet', target_weight: 45.lbs.to_h, target_repetitions: 5, actual_repetitions: nil, target_duration: nil, actual_duration: nil },
        { id: nil, exercise_id: bench_press.id, type: 'WorkSet', target_weight: 45.lbs.to_h, target_repetitions: 5, actual_repetitions: nil, target_duration: nil, actual_duration: nil },
        { id: nil, exercise_id: bench_press.id, type: 'WorkSet', target_weight: 45.lbs.to_h, target_repetitions: 5, actual_repetitions: nil, target_duration: nil, actual_duration: nil },
        { id: nil, exercise_id: bench_press.id, type: 'WorkSet', target_weight: 45.lbs.to_h, target_repetitions: 5, actual_repetitions: nil, target_duration: nil, actual_duration: nil },
        { id: nil, exercise_id: bench_press.id, type: 'WorkSet', target_weight: 45.lbs.to_h, target_repetitions: 5, actual_repetitions: nil, target_duration: nil, actual_duration: nil },
        { id: nil, exercise_id: bench_press.id, type: 'WorkSet', target_weight: 45.lbs.to_h, target_repetitions: 5, actual_repetitions: nil, target_duration: nil, actual_duration: nil },
        { id: nil, exercise_id: barbell_row.id, type: 'WorkSet', target_weight: 45.lbs.to_h, target_repetitions: 5, actual_repetitions: nil, target_duration: nil, actual_duration: nil },
        { id: nil, exercise_id: barbell_row.id, type: 'WorkSet', target_weight: 45.lbs.to_h, target_repetitions: 5, actual_repetitions: nil, target_duration: nil, actual_duration: nil },
        { id: nil, exercise_id: barbell_row.id, type: 'WorkSet', target_weight: 45.lbs.to_h, target_repetitions: 5, actual_repetitions: nil, target_duration: nil, actual_duration: nil },
        { id: nil, exercise_id: barbell_row.id, type: 'WorkSet', target_weight: 45.lbs.to_h, target_repetitions: 5, actual_repetitions: nil, target_duration: nil, actual_duration: nil },
        { id: nil, exercise_id: barbell_row.id, type: 'WorkSet', target_weight: 45.lbs.to_h, target_repetitions: 5, actual_repetitions: nil, target_duration: nil, actual_duration: nil },
      ])
    end
  end

  describe "#create" do
    include_context "stronglifts_program"
    let(:body_weight) { rand(250.0).lbs }

    it "creates the workout with the selected exercises" do
      post :create, params: {
        workout: {
          routine_id: routine_b.id,
          body_weight: { amount: body_weight.amount, unit: body_weight.unit },
          exercise_sets_attributes: [{
            exercise_id: squat.id,
            target_repetitions: 5,
            target_weight: { amount: 200, unit: 'lbs' },
            type: "WorkSet",
          }]
        }
      }, format: :json

      expect(response).to have_http_status(:created)
      expect(user.reload.workouts.count).to eql(1)
      expect(user.last_routine).to eql(routine_b)
      workout = user.workouts.last
      expect(workout.body_weight).to eql(body_weight)
      expect(workout.routine).to eql(routine_b)
      expect(workout.sets.count).to eql(1)
    end
  end
end
