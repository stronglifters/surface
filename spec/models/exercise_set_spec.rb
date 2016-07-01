require 'rails_helper'

describe ExerciseSet do
  subject { build(:exercise_set) }

  describe "#weight_per_side" do
    it 'returns empty bar' do
      subject.target_weight = 45.lbs
      expect(subject.weight_per_side).to be_blank
    end

    it 'returns 25 lbs/side' do
      subject.target_weight = 95.lbs
      expect(subject.weight_per_side).to eql("25.0 lb/side")
    end
  end
end
