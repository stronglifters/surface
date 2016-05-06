require "rails_helper"

feature "Gyms", type: :feature do
  let(:user_session) { create(:active_session, location: create(:calgary)) }

  before :each do
    page.set_rack_session(user_id: user_session.id)
  end

  feature "viewing gyms" do
    subject { GymsPage.new }
    let!(:calgary_gym) { create(:gym, name: "sait", location: create(:calgary)) }
    let!(:edmonton_gym) { create(:gym, name: "nait", location: create(:edmonton)) }

    it "loads the gyms closest to you" do
      subject.visit_page
      expect(subject).to be_on_page
      expect(subject).to have_content(calgary_gym.name)
      expect(subject).not_to have_content(edmonton_gym.name)
    end

    it "loads all the gyms" do
      user_session.location.update_attributes(latitude: 0.0, longitude: 0.0)
      subject.visit_page
      expect(subject).to be_on_page
      expect(subject).to have_content(calgary_gym.name)
      expect(subject).to have_content(edmonton_gym.name)
    end

    describe "search" do
      let!(:other_calgary_gym) { create(:gym, name: "world health", location: create(:calgary)) }

      it "returns gyms that match the search criteria", js: true do
        subject.visit_page
        puts subject.current_path
        subject.search("sait")

        expect(subject).to be_on_page
        expect(subject).to have_content(calgary_gym.name)
        expect(subject).to have_no_content(other_calgary_gym.name)
      end
    end
  end

  feature "adding a gym" do
    subject { NewGymPage.new }

    it "saves a new gym" do
      subject.visit_page
      subject.change(
        name: "SAIT",
        address: "1301 16 Ave NW",
        city: "Calgary",
        region: "AB",
        country: "Canada",
        postal_code: "T2M 0L4",
      )

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
end
