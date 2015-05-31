require "rails_helper"

describe TrainingHistory do
  include_context "stronglifts_program"
  subject { TrainingHistory.new(user, squat) }
  let(:user) { create(:user) }

  describe "#to_line_chart" do
    let(:date) { DateTime.now.utc }
    let(:target_weight) { rand(300) }
    let(:body_weight) { 210 }

    before :each do
      session = user.begin_workout(workout_a, date, body_weight)
      session.train(squat, target_weight, [5, 5, 5, 5, 5])
    end

    it "returns the history in the format required for the chart" do
      result = subject.to_line_chart
      expect(result).to_not be_nil
      expect(result[date.to_i]).to eql(target_weight.to_f)
    end
  end
end
