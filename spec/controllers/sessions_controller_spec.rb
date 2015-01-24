require "rails_helper"

describe SessionsController do
  
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