require 'rails_helper'

describe GymsController do
  let(:user) { create(:user) }

  before :each do
    http_login(user)
  end

  describe "#index" do
    let(:sait) { create(:gym, name: 'sait') }
    let(:world_health) { create(:gym, name: 'world health') }

    it 'returns a list of gyms' do
      get :index

      expect(assigns(:gyms)).to match_array([sait, world_health])
      expect(response).to be_ok
    end
  end
end
