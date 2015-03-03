require "rails_helper"

RSpec.describe ItemsController, type: :controller do
  context "when logged in" do
    let(:user) { create(:user) }

    before :each do
      auth_user(user)
    end

    describe "#index" do
      let(:other_user) { create(:user) }
      let!(:my_item) { create(:item, user: user) }
      let!(:their_item) { create(:item, user: other_user) }

      it "loads all your items" do
        get :index
        expect(assigns(:items)).to match_array([my_item])
      end
    end

    describe "#show" do
      let(:item) { create(:item, user: user) }
      let(:other_user) { create(:user) }
      let(:other_guys_item) { create(:item, user: other_user) }

      it "loads your item" do
        get :show, id: item.id
        expect(assigns(:item)).to eql(item)
      end

      it "does not load other peoples items" do
        get :show, id: other_guys_item.id
        expect(response.status).to eql(404)
      end
    end

    describe "#new" do
      it "loads up an empty item" do
        get :new
        expect(assigns(:item)).to_not be_nil
      end

      it "loads up the params for a new item" do
        get :new, item: { name: 'hammer' }
        expect(assigns(:item).name).to eql('hammer')
      end
    end

    describe "#edit" do
      let(:my_item) { create(:item, user: user) }

      it "loads the item to edit" do
        get :edit, id: my_item.id
        expect(assigns(:item)).to eql(my_item)
      end

      context "when attempting to edit someone elses item" do
        let(:other_item) { create(:item, user: other_user) }
        let(:other_user) { create(:user) }

        it "returns a 404" do
          get :edit, id: other_item.id

          expect(assigns(:item)).to be_nil
          expect(response.status).to eql(404)
        end
      end
    end

    describe "#create" do
      let(:exclusions) { ["id", "user_id"] }
      let(:item_params) do
        build(:item).attributes.reject { |key, _| exclusions.include?(key) }
      end

      it "creates the new item" do
        post :create, item: item_params

        expect(Item.count).to eql(1)
        item = Item.first
        expect(item.user).to eql(user)
        expect(item.name).to eql(item_params["name"])
        expect(item.description).to eql(item_params["description"])
        expect(item.serial_number).to eql(item_params["serial_number"])
        expect(item.purchase_price).to eql(item_params["purchase_price"])
        expect(item.purchased_at.to_i).to eql(item_params["purchased_at"].to_i)
      end

      it "redirects back to the dashboard" do
        put :create, item: item_params

        expect(response).to redirect_to(dashboard_path)
      end
    end

    describe "#update" do
      let(:my_item) { create(:item, user: user) }
      let(:item_params) { build(:item).attributes }

      it "updates the item" do
        patch :update, id: my_item.id, item: item_params

        my_item.reload
        expect(my_item.user).to eql(user)
        expect(my_item.name).to eql(item_params["name"])
        expect(my_item.description).to eql(item_params["description"])
        expect(my_item.serial_number).to eql(item_params["serial_number"])
        expect(my_item.purchase_price).to eql(item_params["purchase_price"])
      end

      it "redirects to the dashboard" do
        patch :update, id: my_item.id, item: item_params

        expect(response).to redirect_to(dashboard_path)
      end
    end

    describe "#destroy" do
      let(:my_item) { create(:item, user: user) }
      let(:other_item) { create(:item, user: other_user) }
      let(:other_user) { create(:user) }

      it "deletes the item" do
        delete :destroy, id: my_item.id

        expect(Item.count).to eql(0)
      end

      it "cannot delete another persons item" do
        delete :destroy, id: other_item.id

        expect(response.status).to eql(404)
      end

      it "redirects to the dashboard" do
        delete :destroy, id: my_item.id

        expect(response).to redirect_to(dashboard_path)
      end
    end
  end
end
