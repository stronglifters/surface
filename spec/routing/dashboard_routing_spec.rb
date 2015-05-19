require "rails_helper"

RSpec.describe "/dashboard", type: :routing do
  it "routes to the items listing" do
    expect(get: "/dashboard").to route_to("sessions#new")
  end
end
