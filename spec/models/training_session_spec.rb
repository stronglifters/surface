require "rails_helper"

describe TrainingSession, type: :model do
  describe "#train" do
    subject { create(:training_session) }
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
      expect(result.sets).to eql(sets.map { |x| x.to_s })
    end
  end
end
