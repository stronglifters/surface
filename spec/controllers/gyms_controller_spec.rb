require 'rails_helper'

describe GymsController do
  let(:user) { create(:user) }

  before :each do
    http_login(user)
  end

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
