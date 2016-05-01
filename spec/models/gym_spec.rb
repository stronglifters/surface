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
end
