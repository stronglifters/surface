require "rails_helper"

describe TrainingSession, type: :model do
  subject { create(:training_session) }

  describe "#train" do
    let(:workout) { subject.workout }
    #let(:sets) { [5, 5, 5, 5, 5] }
    let(:target_weight) { 200 }
    let(:squat) { create(:exercise) }

    before :each do
      workout.add_exercise(squat)
    end

    it "returns a completed exercise" do
      result = subject.train(squat, target_weight, repetitions: 5)

      expect(result).to be_persisted
      expect(result.exercise).to eql(squat)
      expect(result.to_sets).to eql([5])
      expect(result.sets.at(0).exercise).to eql(squat)
      expect(result.sets.at(0).target_weight).to eql(target_weight.to_f)
      expect(result.sets.at(0).target_repetitions).to eql(5)
      expect(result.sets.at(0).actual_repetitions).to eql(5)
    end

    it 'records the next set' do
      subject.train(squat, target_weight, repetitions: 5)
      result = subject.train(squat, target_weight, repetitions: 3)

      expect(result).to be_persisted
      expect(result.exercise).to eql(squat)
      expect(result.to_sets).to eql([5, 3])
      expect(result.sets.at(0).exercise).to eql(squat)
      expect(result.sets.at(0).target_weight).to eql(target_weight.to_f)
      expect(result.sets.at(0).target_repetitions).to eql(5)
      expect(result.sets.at(0).actual_repetitions).to eql(5)
      expect(result.sets.at(1).exercise).to eql(squat)
      expect(result.sets.at(1).target_weight).to eql(target_weight.to_f)
      expect(result.sets.at(1).target_repetitions).to eql(5)
      expect(result.sets.at(1).actual_repetitions).to eql(3)
    end

    it "updates a completed exercise" do
      subject.train(squat, target_weight, repetitions: 5)
      subject.train(squat, target_weight, repetitions: 5)
      subject.train(squat, target_weight, repetitions: 5)

      new_weight = target_weight + 10
      result = subject.train(squat, new_weight, repetitions: 3, set: 2)

      expect(result).to be_persisted
      expect(result.exercise).to eql(squat)
      expect(result.to_sets).to eql([5, 3, 5])
      expect(result.sets.at(0).exercise).to eql(squat)
      expect(result.sets.at(0).target_weight).to eql(target_weight.to_f)
      expect(result.sets.at(0).target_repetitions).to eql(5)
      expect(result.sets.at(0).actual_repetitions).to eql(5)
      expect(result.sets.at(1).exercise).to eql(squat)
      expect(result.sets.at(1).target_weight).to eql(new_weight.to_f)
      expect(result.sets.at(1).target_repetitions).to eql(5)
      expect(result.sets.at(1).actual_repetitions).to eql(3)
      expect(result.sets.at(2).exercise).to eql(squat)
      expect(result.sets.at(2).target_weight).to eql(target_weight.to_f)
      expect(result.sets.at(2).target_repetitions).to eql(5)
      expect(result.sets.at(2).actual_repetitions).to eql(5)
    end

    it "cannot save a duplicate exercise" do
      result = subject.train(squat, target_weight, repetitions: 5)
      subject.train(squat, target_weight, repetitions: 5)

      expect(subject.exercise_sessions.count).to eql(1)
      expect(subject.exercise_sessions).to match_array([result])
    end
  end

  describe "#progress_for" do
    let(:exercise) { create(:exercise) }
    let(:workout) { subject.workout }

    before :each do
      workout.add_exercise(exercise)
      subject.train(exercise, 100, repetitions: 5)
      subject.train(exercise, 100, repetitions: 5)
    end

    it "returns the progress for the specific exercise" do
      result = subject.progress_for(exercise)
      expect(result.exercise).to eql(exercise)
      expect(result.to_sets).to eql([5, 5])
    end
  end
end
