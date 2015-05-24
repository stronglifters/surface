require "rails_helper"

describe "/dashboard", type: :routing do
  it "routes to the items listing" do
    expect(get: "/dashboard").to route_to("training_sessions#index")
  end
end