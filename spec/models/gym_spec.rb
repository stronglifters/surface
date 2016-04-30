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

  describe "#before_save" do
    let(:latitude) { rand(90.0) }
    let(:longitude) { rand(180.0) }

    it 'updates the latitude/logitude' do
      allow(Location).to receive(:from).and_return([latitude, longitude])
      subject.assign_attributes(
        address: '123 street sw',
        city: 'edmonton',
        region: 'alberta',
        country: 'canada',
      )
      subject.save!
      subject.reload

      expect(subject.latitude).to eql(latitude)
      expect(subject.longitude).to eql(longitude)
    end
  end
end
