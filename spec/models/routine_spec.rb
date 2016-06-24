require "rails_helper"

describe Routine do
  subject { build(:routine) }

  describe "#add_exercise" do
    let(:exercise) { create(:exercise) }

    before :each do
      subject.save!
    end

    it "adds a new exercise with the specified sets" do
      sets = rand(10)
      subject.add_exercise(exercise, sets: sets)
      expect(subject.recommendations.first.sets).to eql(sets)
    end

    it "adds the new exercise with the specified reps" do
      repetitions = rand(10)
      subject.add_exercise(exercise, repetitions: repetitions)
      expect(subject.recommendations.first.repetitions).to eql(repetitions)
    end

    it "adds the excercise" do
      subject.add_exercise(exercise)
      expect(subject.recommendations.first.exercise).to eql(exercise)
    end

    it "does not add a duplicate exercise" do
      subject.add_exercise(exercise)
      subject.add_exercise(exercise)
      expect(subject.exercises.count).to eql(1)
      expect(subject.recommendations.count).to eql(1)
    end
  end
end
