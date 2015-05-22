require "rails_helper"

describe ProgramsController do
  let(:user) { create(:user) }

  before :each do
    http_login(user)
  end

  describe "#show" do
    let(:program) { create(:program) }

    it "loads the program" do
      get :show, id: program.to_param
      expect(assigns(:program)).to eql(program)
    end
  end
end
