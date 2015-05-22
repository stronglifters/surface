require 'rails_helper'

describe '/workouts' do
  it 'routes to the workouts/:id' do
    expect(get: '/workouts/A').to route_to(
      controller: 'workouts',
      action: 'show',
      id: 'A'
    )
  end
end
