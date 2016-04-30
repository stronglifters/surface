require 'rails_helper'

describe GymsController do
  describe "#index" do
    let(:sait) { double }
    let(:world_health) { double }

    it 'returns a list of gyms' do
      allow(Gym).to receive(:latest).and_return([sait, world_health])

      get :index

      expect(assigns(:gyms)).to match_array([sait, world_health])
      expect(response).to be_ok
    end
  end
end
