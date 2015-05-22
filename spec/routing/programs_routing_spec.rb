require 'rails_helper'

describe '/programs' do
  it 'routes to /programs/stronglifts-5x5' do
    expect(get: '/programs/stronglifts-5x5').to route_to(
      controller: 'programs',
      action: 'show',
      id: 'stronglifts-5x5'
    )
  end
end
