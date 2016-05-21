require "rails_helper"

describe ImportGymsJob do
  subject { ImportGymsJob.new }
  let(:location) { build(:portland) }

  it 'imports all the gyms in the city' do
    allow(Gym).to receive(:import)
    subject.perform(location)
    expect(Gym).to have_received(:import).with(location.city)
  end

  it 'skips the import if no location is present' do
    allow(Gym).to receive(:import)
    subject.perform(nil)
    expect(Gym).to_not have_received(:import)
  end
end
