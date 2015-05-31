require "rails_helper"

describe TrainingHistory do
  include_context "stronglifts_program"
  subject { TrainingHistory.new(user, squat) }
  let(:user) { create(:user) }

  describe "#to_line_chart" do
    before :each do
      workout_a.exercise_workouts.each do |recommendation|
        user.exercise_sessions.create!(
          target_weight: 200,
          exercise_workout: recommendation,
          sets: [5,5,5,5,5]
        )

        session = user.begin(workout_a)
        session.train(squat, 200, [5,5,5,5,5])
      end
    end

    it "returns the history in the format required for the chart" do
      result = subject.to_line_chart
      expect(result).to_not be_nil
    end
  end
end
