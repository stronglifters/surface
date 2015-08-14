require "rails_helper"

describe ProfilesController do
  
  describe "authenticated" do
    
    describe "#show" do
      include_context "stronglifts_program"

      let(:user) { create(:user) }
      let(:other_user) { create(:user) }

      before :each do
        http_login(user)
      end

      it "loads the user's profile" do
        get :show, id: user.to_param
        expect(assigns(:user)).to eql(user)
        expect(assigns(:program)).to eql(Program.stronglifts)
      end
      it "loads the other user's profile" do
        get :show, id: other_user.to_param
        expect(assigns(:user)).to eql(other_user)
        expect(assigns(:program)).to eql(Program.stronglifts)
      end
    end

    describe "#edit" do
      include_context "stronglifts_program"

      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      
      before :each do
        http_login(user)
      end

      it "loads the user's profile into an edit view" do
        get :edit, id: user.to_param
        expect(assigns(:user)).to eql(user)
        expect(assigns(:program)).to eql(Program.stronglifts)
      end
      
      it "will not load the other user's profile into an edit view" do
        get :edit, id: other_user.to_param
        expect(assigns(:user)).to eql(user)
        expect(assigns(:program)).to eql(Program.stronglifts)
      end
      
    end
    
    describe "#update" do
      include_context "stronglifts_program"

      let(:user) { create(:user) }
      
      before :each do
        http_login(user)
      end
      
      it "updates the user profile" do
        patch :update, id: user.to_param, profile: {gender: "male"}
        user.reload
        expect(user.profile.male?).to be_truthy
        expect(response).to redirect_to(profile_path(user.profile))
      end
      
    end
    
  end
  
  describe "unauthenticated" do
    
    describe "#show" do
      include_context "stronglifts_program"

      let(:user) { create(:user) }

      it "loads the user's profile" do
        get :show, id: user.to_param
        expect(assigns(:user)).to eql(nil)
        expect(assigns(:program)).to eql(nil)
      end
    end

    describe "#edit" do
      include_context "stronglifts_program"

      let(:user) { create(:user) }

      it "loads the user's profile into an edit view" do
        get :edit, id: user.to_param
        expect(assigns(:user)).to eql(nil)
        expect(assigns(:program)).to eql(nil)
      end
    end
    
  end
    
end
