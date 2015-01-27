require "rails_helper"

describe SessionsController do
  
  describe "#create" do
    context "when credentials are correct" do
      
      let(:user) { create(:user, password: "password") }
      
      it "logs you in with email" do
        post :create, { username: user.email, password: "password" }
        expect(session[:user_id]).to eql(user.id)
      end
      
      it "logs you in with username" do
        post :create, { username: user.username, password: "password" }
        expect(session[:user_id]).to eql(user.id)
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