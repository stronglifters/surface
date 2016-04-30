require 'rails_helper'

describe "/gyms" do
  it 'routes to gyms#index' do
    expect(get: "/gyms").to route_to(controller: 'gyms', action: 'index')
  end
end
