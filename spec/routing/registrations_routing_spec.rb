require 'rails_helper'

describe '/registrations' do
  it 'routes to the create action' do
    expect(post: 'registrations').to route_to(controller: 'registrations', action: 'create')
  end
end
