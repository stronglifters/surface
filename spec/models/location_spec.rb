require 'rails_helper'

describe Location do
  describe '.from' do
    it 'returns the correct lat/long' do
      latitude, longitude = Location.
        from('1301 16 Ave NW', 'Calgary', 'AB', 'Canada')

      expect(latitude).to be_within(0.1).of(51.0647815)
      expect(longitude).to be_within(0.1).of(-114.0927691)
    end
  end
end
