require "rails_helper"

describe ProfilesController do
  describe "#show" do
    include_context "stronglifts_program"

    let(:user) { create(:user) }

    it "loads the users profile" do
      get :show, id: user.username
      expect(assigns(:user)).to eql(user)
      expect(assigns(:program)).to eql(Program.stronglifts)
    end
  end
end
