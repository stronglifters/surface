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
      expect(json[:exercises]).to match_array([
        { id: barbell_row.id, name: barbell_row.name, },
        { id: bench_press.id, name: bench_press.name, },
        { id: dips.id, name: dips.name, },
        { id: planks.id, name: planks.name, },
        { id: squat.id, name: squat.name, },
      ])
    end
  end
end
