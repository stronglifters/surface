require "rails_helper"

describe Workout do
  subject { build(:workout) }

  describe "#add_exercise" do
    let(:exercise) { create(:exercise) }

    before :each do
      subject.save!
    end

    it "adds a new exercise with the specified sets" do
      sets = rand(10)
      subject.add_exercise(exercise, sets: sets)
      expect(subject.exercise_workouts.first.sets).to eql(sets)
    end

    it "adds the new exercise with the specified reps" do
      repetitions = rand(10)
      subject.add_exercise(exercise, repetitions: repetitions)
      expect(subject.exercise_workouts.first.repetitions).to eql(repetitions)
    end

    it "adds the excercise" do
      subject.add_exercise(exercise)
      expect(subject.exercise_workouts.first.exercise).to eql(exercise)
    end
  end
end
