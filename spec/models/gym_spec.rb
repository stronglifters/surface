require 'rails_helper'

describe Gym do
  subject { build(:gym) }

  describe "#validations" do
    it 'validates the presence of name' do
      subject.name = nil
      expect(subject).to be_invalid
      expect(subject.errors[:name]).to be_present
    end
  end

  describe "#location" do
    it 'updates the location' do
      subject.location_attributes = {
        address: '123 street sw',
        city: 'edmonton',
        region: 'alberta',
        country: 'canada',
      }
      subject.save!

      expect(subject.location.address).to eql('123 street sw')
      expect(subject.location.city).to eql('edmonton')
      expect(subject.location.region).to eql('alberta')
      expect(subject.location.country).to eql('canada')
    end
  end

  describe ".closest_to" do
    let(:calgary) { create(:calgary) }
    let(:edmonton) { create(:edmonton) }
    let!(:calgary_gym) { create(:gym, location: calgary) }
    let!(:edmonton_gym) { create(:gym, location: edmonton) }

    it 'returns gyms near the location' do
      results = Gym.closest_to(calgary)
      expect(results).to match_array([calgary_gym])
    end

    it 'returns all the gyms' do
      results = Gym.closest_to(nil)
      expect(results).to match_array([calgary_gym, edmonton_gym])
    end

    it 'returns all the gym when coordinates are empty' do
      results = Gym.closest_to(build(:no_where))
      expect(results).to match_array([calgary_gym, edmonton_gym])
    end
  end

  describe '.search_with' do
    let!(:calgary_gym) { create(:gym, name: 'SAIT', location: create(:calgary)) }
    let!(:edmonton_gym) { create(:gym, name: 'NAIT', location: create(:edmonton)) }
    let!(:portland_gym) { create(:gym, name: '24 Hour Fitness', location: create(:portland)) }

    it 'returns all gyms' do
      results = Gym.search_with({})
      expect(results).to match_array([calgary_gym, edmonton_gym, portland_gym])
    end

    it 'returns gyms with a matching name' do
      results = Gym.search_with(q: 'sait')
      expect(results).to match_array([calgary_gym])
    end

    it 'returns all gyms from a city' do
      results = Gym.search_with(q: 'calgary')
      expect(results).to match_array([calgary_gym])
    end

    it 'returns all gyms from a region' do
      results = Gym.search_with(q: 'AB')
      expect(results).to match_array([calgary_gym, edmonton_gym])
    end

    it 'returns all gyms from a country' do
      results = Gym.search_with(q: 'US')
      expect(results).to match_array([portland_gym])
    end
  end

  describe ".search_yelp", skip: !ENV['YELP_CONSUMER_KEY'].present? do
    it 'returns results' do
      results = Gym.search_yelp(city: "Calgary")
      expect(results).to be_present
      expect(results.count).to be > 0
      expect(results.first).to be_instance_of(Gym)
    end

    it 'returns the next page of results' do
      results = Gym.search_yelp(city: "Calgary", page: 2)
      expect(results).to be_present
      expect(results.count).to be > 0
      expect(results.first).to be_instance_of(Gym)
    end
  end
end
