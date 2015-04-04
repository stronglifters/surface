require "rails_helper"

describe ApplicationController, type: :controller do
  controller do
    def index
      render text: "WHAT?"
    end
  end

  context "when not logged in" do
    it "redirects you to the login page" do
      get :index
      expect(response).to redirect_to(new_session_path)
    end
  end

  context "when logged in" do
    let(:user) { create(:user) }

    it "allows the action to do it's thing" do
      auth_user(user)
      get :index
      expect(response.body).to eql("WHAT?")
    end
  end
end
