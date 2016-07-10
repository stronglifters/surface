require "rails_helper"

describe ExerciseSet do
  subject { build(:work_set) }

  describe "#weight_per_side" do
    it "returns empty bar" do
      subject.target_weight = 45.lbs
      expect(subject.weight_per_side).to be_blank
    end

    it "returns 25 lbs/side" do
      subject.target_weight = 95.lbs
      expect(subject.weight_per_side).to eql("25.0 lbs/side")
    end
  end

  describe ".for" do
    let(:squat) { create(:exercise) }
    let(:dip) { create(:exercise) }

    it "returns all sets for the exercise only" do
      squat_set = create(:work_set, exercise: squat)
      _ = create(:work_set, exercise: dip)

      expect(ExerciseSet.for(squat)).to match_array([squat_set])
    end

    it "returns nil" do
      expect(ExerciseSet.for(squat)).to be_empty
    end
  end

  describe "#target_weight" do
    it 'saves lbs' do
      subject.target_weight = 45.lbs
      subject.save!
      expect(subject.reload.target_weight).to eql(45.lbs)
    end

    it 'saves kgs' do
      subject.target_weight = 20.kg
      subject.save!
      expect(subject.reload.target_weight).to eql(20.kg)
    end
  end
end
