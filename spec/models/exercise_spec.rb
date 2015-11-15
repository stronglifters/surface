require "rails_helper"

describe Exercise do
  describe "#short_name" do
    it "returns the acronym for the exercise" do
      expect(build(:exercise, name: "Squat").short_name).to eql("S")
      expect(build(:exercise, name: "Bench Press").short_name).to eql("BP")
      expect(build(:exercise, name: "Deadlift").short_name).to eql("D")
      expect(build(:exercise, name: "Overhead Press").short_name).to eql("OP")
    end
  end
end
