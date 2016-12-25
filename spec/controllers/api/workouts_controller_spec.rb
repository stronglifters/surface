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
        { id: dips.id, name: dips.name, },
        { id: planks.id, name: planks.name, },
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
        { id: nil, exercise_id: dips.id, type: 'WorkSet', target_weight: 45.lbs.to_h, target_repetitions: 5, actual_repetitions: nil, target_duration: nil, actual_duration: nil },
        { id: nil, exercise_id: dips.id, type: 'WorkSet', target_weight: 45.lbs.to_h, target_repetitions: 5, actual_repetitions: nil, target_duration: nil, actual_duration: nil },
        { id: nil, exercise_id: dips.id, type: 'WorkSet', target_weight: 45.lbs.to_h, target_repetitions: 5, actual_repetitions: nil, target_duration: nil, actual_duration: nil },
        { id: nil, exercise_id: planks.id, type: 'WorkSet', target_weight: 0.lbs.to_h, target_repetitions: 1, actual_repetitions: nil, target_duration: 60, actual_duration: nil },
        { id: nil, exercise_id: planks.id, type: 'WorkSet', target_weight: 0.lbs.to_h, target_repetitions: 1, actual_repetitions: nil, target_duration: 60, actual_duration: nil },
        { id: nil, exercise_id: planks.id, type: 'WorkSet', target_weight: 0.lbs.to_h, target_repetitions: 1, actual_repetitions: nil, target_duration: 60, actual_duration: nil },
      ])
    end
  end
end
