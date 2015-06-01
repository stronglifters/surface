require "rails_helper"

describe "/profiles" do
  it "routes to /profiles/<username>" do
    expect(get: "/profiles/mokha").to route_to(
      controller: "profiles",
      action: "show",
      id: "mokha"
    )
  end

  it "routes to /u/<username>" do
    expect(get: "/u/mokha").to route_to(
      controller: "profiles",
      action: "show",
      id: "mokha"
    )
  end
end
