require "rails_helper"

describe WorkoutsController do
  let(:user) { create(:user) }

  before :each do
    http_login(user)
  end

  describe "#show" do
    let(:workout) { create(:workout) }

    it "loads the workout" do
      get :show, id: workout.slug
      expect(assigns(:workout)).to eql(workout)
    end
  end
end
