require 'rails_helper'

describe "root route" do
  it 'routes to the login page' do
    expect(get: '/').to route_to(controller: 'sessions', action: 'new')
  end
end

describe "terms route" do
  it 'routes to the terms and conditions page' do
    expect(get: '/terms').
      to route_to(controller: 'static_pages', action: 'terms')
  end
end
