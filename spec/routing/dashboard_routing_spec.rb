require "rails_helper"

describe "/dashboard", type: :routing do
  it "routes to the items listing" do
    expect(get: "/dashboard").to route_to("dashboards#show")
  end
end
