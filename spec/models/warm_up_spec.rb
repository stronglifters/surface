require "rails_helper"

describe WarmUp do
  describe ".new" do
    describe "squat" do
      let(:squat) { build(:exercise, name: "Squat") }

      (45..60).step(5).each do |target_weight|
        it "has zero warm up sets" do
          expect(WarmUp.new(squat, target_weight).sets).to be_empty
        end
      end

      (65..400).step(5).each do |target_weight|
        it "calculates the warm up sets at #{target_weight} lbs" do
          sets = WarmUp.new(squat, target_weight).sets
          expect(sets).to be_present
          if target_weight >= 350
            expect(sets.length).to eql(9)
          elsif target_weight > 300
            expect(sets.length).to eql(8)
          elsif target_weight > 265
            expect(sets.length).to eql(7)
          elsif target_weight > 220
            expect(sets.length).to eql(6)
          elsif target_weight > 180
            expect(sets.length).to eql(5)
          elsif target_weight > 130
            expect(sets.length).to eql(4)
          elsif target_weight > 90
            expect(sets.length).to eql(3)
          elsif target_weight > 60
            expect(sets.length).to eql(2)
          end
        end
      end
    end

    describe "barbell row" do
      let(:barbell_row) { build(:exercise, name: "Barbell Row") }

      (45..100).step(5).each do |target_weight|
        it "has zero warm up sets" do
          expect(WarmUp.new(barbell_row, target_weight).sets).to be_empty
        end
      end

      (105..400).step(5).each do |target_weight|
        it "calculates the warm up sets for #{target_weight} lbs" do
          sets = WarmUp.new(barbell_row, target_weight).sets
          expect(sets).to be_present
          if target_weight >= 350
            expect(sets.length).to eql(6)
          elsif target_weight > 300
            expect(sets.length).to eql(5)
          elsif target_weight > 265
            expect(sets.length).to eql(4)
          elsif target_weight > 220
            expect(sets.length).to eql(3)
          elsif target_weight > 180
            expect(sets.length).to eql(2)
          elsif target_weight > 100
            expect(sets.length).to eql(1)
          end
        end
      end
    end

    describe "deadlift" do
      let(:deadlift) { build(:exercise, name: "Deadlift") }

      (45..150).step(5).each do |target_weight|
        it "has zero warm up sets at #{target_weight} lbs" do
          expect(WarmUp.new(deadlift, target_weight).sets).to be_empty
        end
      end

      (155..400).step(5).each do |target_weight|
        it "calculates the warm up sets for #{target_weight} lbs" do
          sets = WarmUp.new(deadlift, target_weight).sets
          expect(sets).to be_present
          if target_weight >= 350
            expect(sets.length).to eql(6)
          elsif target_weight > 300
            expect(sets.length).to eql(5)
          elsif target_weight > 265
            expect(sets.length).to eql(4)
          elsif target_weight > 220
            expect(sets.length).to eql(3)
          elsif target_weight > 170
            expect(sets.length).to eql(2)
          elsif target_weight > 100
            expect(sets.length).to eql(1)
          else
            puts [target_weight, sets.map(&:target_weight)].inspect
          end
        end
      end
    end
  end
end
