require 'rails_helper'

describe "root route" do
  it 'routes to the login page' do
    expect(get: '/').to route_to(controller: 'sessions', action: 'new')
  end
end
