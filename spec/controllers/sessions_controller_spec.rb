require "rails_helper"

describe SessionsController do
  describe "#new" do
    context "when already logged in" do
      let(:user) { create(:user) }

      it 'redirects to the dashboard' do
        http_login(user)
        get :new
        expect(response).to redirect_to(dashboard_path)
      end
    end

    it 'loads a new user' do
      get :new
      expect(assigns(:user)).to be_new_record
    end
  end

  describe "#create" do
    let(:user) { create(:user, password: "password") }

    context "when credentials are correct" do
      it "logs you in with email" do
        post :create, params: {
          user: { username: user.email, password: "password" }
        }
        expect(session[:user_id]).to eql(UserSession.last.id)
      end

      it "logs you in with username" do
        post :create, params: {
          user: { username: user.username, password: "password" }
        }
        expect(session[:user_id]).to eql(UserSession.last.id)
      end

      it "redirects to the dashboard" do
        post :create, params: {
          user: { username: user.username, password: "password" }
        }
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when credentials are incorrect" do
      it "displays errors" do
        post :create, params: {
          user: { username: user.username, password: "wrong" }
        }
        expect(flash[:warning]).to_not be_empty
      end

      it "redirects to the login page" do
        post :create, params: {
          user: { username: user.username, password: "wrong" }
        }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "#destroy" do
    context "when logged in" do
      let(:user) { create(:user) }
      let(:user_session) { create(:active_session, user: user) }

      it "logs you out" do
        session[:user_id] = user_session.id

        delete :destroy, params: { id: user.id }

        expect(session[:user_id]).to be_nil
        expect(user_session.reload.revoked_at).to be_present
      end
    end
  end
end
