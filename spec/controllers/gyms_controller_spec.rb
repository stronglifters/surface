require "rails_helper"

describe GymsController do
  let(:user) { create(:user) }
  let(:user_session) { create(:user_session, location: portland, user: user) }
  let(:portland) { create(:portland) }

  before :each do
    http_login(user, user_session)
  end

  describe "#index" do
    let!(:sait) { create(:portland_gym, name: "sait") }
    let!(:world_health) { create(:portland_gym, name: "world health") }

    it "returns a list of gyms" do
      get :index

      expect(assigns(:gyms)).to match_array([sait, world_health])
      expect(response).to be_ok
    end

    it "returns matching results" do
      get :index, q: "sait"

      expect(assigns(:gyms)).to match_array([sait])
      expect(response).to be_ok
    end

    it "returns matches from yelp" do
      gym = build(:gym)
      allow(Search).to receive(:yelp).and_return(Kaminari.paginate_array([gym]))
      get :index, q: "sait", source: "yelp"

      expect(assigns(:gyms)).to match_array([gym])
      expect(response).to be_ok
    end
  end

  describe "#new" do
    it "loads the new page" do
      get :new
      expect(response).to be_ok
      expect(assigns(:gym)).to be_instance_of(Gym)
      expect(assigns(:gym).location).to be_present
    end

    it "loads the available countries" do
      get :new
      expect(assigns(:countries).count).to eql(248)
      expect(assigns(:countries)).to include(%w{Canada CA})
    end
  end

  describe "#create" do
    context "valid params" do
      before :each do
        post :create, gym: {
          name: "SAIT",
          location_attributes: {
            address: "1301 16 Ave NW",
            city: "Calgary",
            region: "AB",
            country: "CA",
            postal_code: "T2M 0L4",
          }
        }
      end

      it "redirects to the listing page" do
        expect(response).to redirect_to(gyms_path(q: "SAIT"))
      end

      it "creates a new gym" do
        expect(Gym.count).to eql(1)
        gym = Gym.last
        expect(gym.name).to eql("SAIT")
        expect(gym.location).to be_present
        expect(gym.location.address).to eql("1301 16 Ave NW")
        expect(gym.location.city).to eql("Calgary")
        expect(gym.location.region).to eql("AB")
        expect(gym.location.country).to eql("CA")
        expect(gym.location.postal_code).to eql("T2M 0L4")
      end
    end

    context "invalid params" do
      before :each do
        post :create, gym: { name: "" }
      end

      it "displays an error" do
        expect(flash[:error]).to eql(assigns(:gym).errors.full_messages)
      end

      it "renders the form with the original values entered" do
        expect(response).to render_template(:new)
        expect(assigns(:gym)).to be_present
      end
    end
  end

  describe "#show" do
    it "loads the gym" do
      gym = create(:gym)
      get :show, id: gym.id
      expect(assigns(:gym)).to eql(gym)
    end
  end
end
