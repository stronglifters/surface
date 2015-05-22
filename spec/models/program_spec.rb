require 'rails_helper'

describe Program do
  it 'saves a slug' do
    program = create(:program, name: 'Strong Lifts 5x5')
    expect(program.slug).to eql('strong-lifts-5x5')
  end
end
