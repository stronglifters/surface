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
      sets = subject.sets.to_a
      expect(sets.at(0).exercise).to eql(squat)
      expect(sets.at(0).target_weight).to eql(target_weight.to_f)
      expect(sets.at(0).target_repetitions).to eql(5)
      expect(sets.at(0).actual_repetitions).to eql(5)
    end

    it "records the next set" do
      subject.train(squat, target_weight, repetitions: 5)
      result = subject.train(squat, target_weight, repetitions: 3)

      expect(result).to be_persisted
      expect(result.exercise).to eql(squat)
      expect(subject.progress_for(squat).to_sets).to eql([5, 3])
      sets = subject.sets.in_order.to_a
      set = sets.at(0)
      expect(set.exercise).to eql(squat)
      expect(set.target_weight).to eql(target_weight.to_f)
      expect(set.target_repetitions).to eql(5)
      expect(set.actual_repetitions).to eql(5)
      set = sets.at(1)
      expect(set.exercise).to eql(squat)
      expect(set.target_weight).to eql(target_weight.to_f)
      expect(set.target_repetitions).to eql(5)
      expect(set.actual_repetitions).to eql(3)
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
      sets = progress.sets.to_a
      expect(sets.at(0).exercise).to eql(squat)
      expect(sets.at(0).target_weight).to eql(target_weight.to_f)
      expect(sets.at(0).target_repetitions).to eql(5)
      expect(sets.at(0).actual_repetitions).to eql(5)
      expect(sets.at(1).exercise).to eql(squat)
      expect(sets.at(1).target_weight).to eql(new_weight.to_f)
      expect(sets.at(1).target_repetitions).to eql(5)
      expect(sets.at(1).actual_repetitions).to eql(3)
      expect(sets.at(2).exercise).to eql(squat)
      expect(sets.at(2).target_weight).to eql(target_weight.to_f)
      expect(sets.at(2).target_repetitions).to eql(5)
      expect(sets.at(2).actual_repetitions).to eql(5)
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

  describe ".since" do
    subject { described_class }

    it 'returns workouts that occurred after the date given' do
      monday = create(:workout, occurred_at: 3.days.ago)
      wednesday = create(:workout, occurred_at: 1.day.ago)

      expect(subject.since(2.days.ago)).to match_array([wednesday])
    end
  end

  describe ".to_line_chart" do
    let(:routine) { subject.routine }
    let(:squat) { create(:exercise) }

    it 'returns a single series' do
      routine.add_exercise(squat)
      subject.train(squat, 315, repetitions: 5)
      subject.reload

      expect(described_class.to_line_chart).to eql({
        subject.occurred_at => 315.0
      })
    end
  end
end
