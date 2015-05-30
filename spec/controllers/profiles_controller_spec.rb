require "rails_helper"

describe ProfilesController do
  describe "#show" do
    let(:user) { create(:user) }

    it "loads the users profile" do
      get :show, id: user.username
      expect(assigns(:user)).to eql(user)
    end
  end
end
