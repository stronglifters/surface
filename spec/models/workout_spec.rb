require "rails_helper"

describe Workout, type: :model do
  subject { create(:workout) }

  describe "#train" do
    let(:routine) { subject.routine }
    let(:target_weight) { 200 }
    let(:squat) { create(:exercise) }

    before :each do
      routine.add_exercise(squat)
    end

    it "returns a completed exercise" do
      result = subject.train(squat, target_weight, repetitions: 5)

      expect(result).to be_persisted
      expect(result.exercise).to eql(squat)
      expect(subject.progress_for(squat).to_sets).to eql([5])
      expect(subject.sets.at(0).exercise).to eql(squat)
      expect(subject.sets.at(0).target_weight).to eql(target_weight.to_f)
      expect(subject.sets.at(0).target_repetitions).to eql(5)
      expect(subject.sets.at(0).actual_repetitions).to eql(5)
    end

    it 'records the next set' do
      subject.train(squat, target_weight, repetitions: 5)
      result = subject.train(squat, target_weight, repetitions: 3)

      expect(result).to be_persisted
      expect(result.exercise).to eql(squat)
      expect(subject.progress_for(squat).to_sets).to eql([5, 3])
      expect(subject.sets.at(0).exercise).to eql(squat)
      expect(subject.sets.at(0).target_weight).to eql(target_weight.to_f)
      expect(subject.sets.at(0).target_repetitions).to eql(5)
      expect(subject.sets.at(0).actual_repetitions).to eql(5)
      expect(subject.sets.at(1).exercise).to eql(squat)
      expect(subject.sets.at(1).target_weight).to eql(target_weight.to_f)
      expect(subject.sets.at(1).target_repetitions).to eql(5)
      expect(subject.sets.at(1).actual_repetitions).to eql(3)
    end

    it "updates a completed exercise" do
      subject.train(squat, target_weight, repetitions: 5)
      subject.train(squat, target_weight, repetitions: 5)
      subject.train(squat, target_weight, repetitions: 5)

      new_weight = target_weight + 10
      result = subject.train(squat, new_weight, repetitions: 3, set: 1)

      expect(result).to be_persisted
      expect(result.exercise).to eql(squat)
      progress = subject.progress_for(squat)
      expect(progress.to_sets).to eql([5, 3, 5])
      expect(progress.sets.at(0).exercise).to eql(squat)
      expect(progress.sets.at(0).target_weight).to eql(target_weight.to_f)
      expect(progress.sets.at(0).target_repetitions).to eql(5)
      expect(progress.sets.at(0).actual_repetitions).to eql(5)
      expect(progress.sets.at(1).exercise).to eql(squat)
      expect(progress.sets.at(1).target_weight).to eql(new_weight.to_f)
      expect(progress.sets.at(1).target_repetitions).to eql(5)
      expect(progress.sets.at(1).actual_repetitions).to eql(3)
      expect(progress.sets.at(2).exercise).to eql(squat)
      expect(progress.sets.at(2).target_weight).to eql(target_weight.to_f)
      expect(progress.sets.at(2).target_repetitions).to eql(5)
      expect(progress.sets.at(2).actual_repetitions).to eql(5)
    end

    it "cannot save a duplicate exercise" do
      subject.train(squat, target_weight, repetitions: 5, set: 0)
      subject.train(squat, target_weight, repetitions: 5, set: 0)

      expect(subject.sets.count).to eql(1)
    end
  end

  describe "#progress_for" do
    let(:exercise) { create(:exercise) }
    let(:other_exercise) { create(:exercise) }
    let(:routine) { subject.routine }

    before :each do
      routine.add_exercise(exercise)
      routine.add_exercise(other_exercise)
      subject.train(exercise, 100, repetitions: 5)
      subject.train(other_exercise, 100, repetitions: 5)
      subject.train(exercise, 100, repetitions: 5)
    end

    it "returns the progress for the specific exercise" do
      result = subject.progress_for(exercise)
      expect(result.exercise).to eql(exercise)
      expect(result.to_sets).to eql([5, 5])
    end
  end
end
