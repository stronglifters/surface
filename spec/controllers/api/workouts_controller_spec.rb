require "rails_helper"

describe Api::WorkoutsController do
  describe "#index" do
    render_views
    let(:user) { create(:user) }

    before :each do
      api_login(user)
    end

    it "returns each workout" do
      workout = create(:workout, user: user)

      get :index, format: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:workouts].count).to eql(1)
    end
  end
end
