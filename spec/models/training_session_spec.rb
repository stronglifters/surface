require "rails_helper"

describe TrainingSession, type: :model do
  subject { create(:training_session) }

  describe "#train" do
    let(:workout) { subject.workout }
    let(:sets) { [5, 5, 5, 5, 5] }
    let(:target_weight) { 200 }
    let(:squat) { create(:exercise) }

    before :each do
      workout.add_exercise(squat)
    end

    it "returns a completed exercise" do
      result = subject.train(squat, target_weight, sets)
      expect(result).to be_persisted
      expect(result.target_weight).to eql(target_weight.to_f)
      expect(result.exercise).to eql(squat)
      expect(result.sets).to eql(sets.map(&:to_s))
    end
  end

  describe "#progress_for" do
    let(:exercise) { create(:exercise) }
    let(:workout) { subject.workout }

    before :each do
      workout.add_exercise(exercise)
      subject.train(exercise, 100, [5, 5])
    end

    it "returns the progress for the specific exercise" do
      result = subject.progress_for(exercise)
      expect(result.exercise).to eql(exercise)
      expect(result.sets).to eql(["5", "5"])
      expect(result.target_weight).to eql(100.0)
    end
  end
end
