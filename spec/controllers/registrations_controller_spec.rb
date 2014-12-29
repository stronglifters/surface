require 'rails_helper'

describe RegistrationsController do
  describe "#new" do
    it "loads a new user" do
      get :new
      expect(assigns(:user)).to be_new_record
    end
  end
end