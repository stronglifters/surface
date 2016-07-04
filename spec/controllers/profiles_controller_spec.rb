require "rails_helper"

describe ProfilesController do
  describe "authenticated" do
    include_context "stronglifts_program"
    let(:user) { create(:user) }

    before :each do
      http_login(user)
    end

    describe "#show" do
      let(:other_user) { create(:user) }

      it "loads the user's profile" do
        get :show, params: { id: user.to_param }
        expect(assigns(:user)).to eql(user)
        expect(assigns(:profile)).to eql(user.profile)
        expect(assigns(:program)).to eql(Program.stronglifts)
      end

      it "loads the other user's profile" do
        get :show, params: { id: other_user.to_param }
        expect(assigns(:user)).to eql(other_user)
        expect(assigns(:profile)).to eql(other_user.profile)
        expect(assigns(:program)).to eql(Program.stronglifts)
      end
    end

    describe "#edit" do
      let(:other_user) { create(:user) }

      it "loads the user's profile into an edit view" do
        get :edit, params: { id: user.to_param }
        expect(assigns(:profile)).to eql(user.profile)
        expect(assigns(:program)).to eql(Program.stronglifts)
      end

      it "will not load the other user's profile into an edit view" do
        get :edit, params: { id: other_user.to_param }
        expect(assigns(:profile)).to eql(user.profile)
        expect(assigns(:program)).to eql(Program.stronglifts)
      end
    end

    describe "#update" do
      it "updates the user profile" do
        patch :update, params: {
          id: user.to_param, profile: { gender: "male" }
        }
        user.reload
        expect(user.profile.male?).to be_truthy
        expect(response).to redirect_to(profile_path(user.profile))
      end

      it 'saves the users home gym' do
        gym = create(:gym)

        patch :update, params: {
          id: user.to_param, profile: { gym_id: gym.id }
        }

        expect(user.reload.profile.gym).to eql(gym)
      end
    end
  end

  describe "unauthenticated" do
    include_context "stronglifts_program"
    let(:user) { create(:user) }

    describe "#show" do
      it "loads the user's profile" do
        get :show, params: { id: user.to_param }
        expect(assigns(:user)).to be_nil
        expect(assigns(:program)).to be_nil
      end
    end

    describe "#edit" do
      it "loads the user's profile into an edit view" do
        get :edit, params: { id: user.to_param }
        expect(assigns(:user)).to be_nil
        expect(assigns(:program)).to be_nil
      end
    end
  end
end
