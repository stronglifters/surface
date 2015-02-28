require 'rails_helper'

RSpec.describe ItemsController, type: :controller do

  context "when logged in" do
    let(:user) { create(:user) }

    before :each do
      session[:user_id] = user.id
    end

    describe "#index" do
      let(:other_user) { create(:user) }
      let!(:my_item) { create(:item, user: user) }
      let!(:their_item) { create(:item, user: other_user) }

      it 'loads all your items' do
        get :index
        expect(assigns(:items)).to match_array([my_item])
      end
    end
  end
end
