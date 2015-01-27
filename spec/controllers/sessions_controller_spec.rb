require "rails_helper"

describe SessionsController do
  
  describe "#create" do
    
    let(:user) { create(:user, password: "password") }
    
    context "when credentials are correct" do
      
      it "logs you in with email" do
        post :create, { user: { username: user.email, password: "password" } }
        expect(session[:user_id]).to eql(user.id)
      end
      
      it "logs you in with username" do
        post :create, { user: { username: user.username, password: "password" } }
        expect(session[:user_id]).to eql(user.id)
      end
      
    end
    
    context "when credentials are incorrect" do
      
      it "displays errors" do
        post :create, { user: { username: user.username, password: "wrong" } }
        expect(flash[:warning]).to_not be_empty
      end
      
      it "redirects to the login page" do
        post :create, { user: { username: user.username, password: "wrong" } }
        expect(response).to redirect_to(new_session_path)
      end
      
    end
  end
  
  describe "#destroy" do
    context "when logged in" do
      
      let(:user) { create(:user) }
      
      it "logs you out" do
        session[:user_id] = user.id
        delete :destroy, id: user.id
        expect(session[:user_id]).to be_nil
      end
      
    end
  end
  
end