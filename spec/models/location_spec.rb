require 'rails_helper'

describe Location do
  describe '.from' do
    it 'returns the correct lat/long' do
      latitude, longitude = Location.
        from('1817 Crowchild Trail NW', 'Calgary', 'AB', 'Canada')
      expect(latitude).to be_within(0.1).of(51.0706973)
      expect(longitude).to be_within(0.1).of(-114.1178249)
    end
  end
end
