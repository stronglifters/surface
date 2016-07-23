require "rails_helper"

describe Program do
  it "saves a slug" do
    program = create(:program, name: "Strong Lifts 5x5")
    expect(program.slug).to eql("strong-lifts-5x5")
  end

  describe ".stronglifts" do
    include_context "stronglifts_program"

    it "returns the stronglifts program" do
      expect(Program.stronglifts).to eql(program)
    end
  end

  describe "#prepare_sets_for" do
    include_context "stronglifts_program"
    subject { Program.stronglifts }

    describe "squat" do
      let(:user) { build(:user) }

      it "returns 5 work sets of 5 repetitions" do
        sets = subject.prepare_sets_for(user, squat)
        worksets = sets.select(&:work?)
        expect(worksets.length).to eql(5)
        expect(worksets.map(&:target_repetitions)).to match_array([5, 5, 5, 5, 5])
      end

      it "returns 3 sets of 5 repetitions when the last workout was 3x5" do
        workout = create(:workout, user: user, routine: routine_a)
        3.times { workout.train(squat, 45, repetitions: 5) }

        sets = subject.prepare_sets_for(user, squat)
        worksets = sets.select(&:work?)
        expect(worksets.length).to eql(3)
        expect(worksets.map(&:target_repetitions)).to match_array([5, 5, 5])
      end

      it "returns the correct exercise for each set" do
        sets = subject.prepare_sets_for(user, squat)
        expect(sets.map(&:exercise).uniq).to match_array([squat])
      end

      it "returns 45 lbs for the first workout" do
        sets = subject.prepare_sets_for(user, squat).select(&:work?)
        expect(sets.map(&:target_weight).uniq).to match_array([45.lbs])
      end

      it "returns 50 lbs for the second workout" do
        workout = create(:workout, user: user, routine: routine_a)
        5.times { workout.train(squat, 45, repetitions: 5) }

        sets = subject.prepare_sets_for(user, squat).select(&:work?)
        expect(sets.map(&:target_weight).uniq).to match_array([50.lbs])
      end

      it "returns the same weight after a failed workout" do
        workout = create(:workout, user: user, routine: routine_a)
        5.times { |n| workout.train(squat, 45, repetitions: n) }

        sets = subject.prepare_sets_for(user, squat).select(&:work?)
        expect(sets.map(&:target_weight).uniq).to match_array([45.lbs])
      end

      it "deloads you by 10% after 3 consecutive failed workouts" do
        3.times do
          workout = create(:workout, user: user, routine: routine_a)
          5.times { |n| workout.train(squat, 310, repetitions: n) }
        end

        sets = subject.prepare_sets_for(user, squat).select(&:work?)
        expect(sets.map(&:target_weight).uniq).to match_array([275.lbs])
      end

      describe "warmup" do
        describe "when the workset is less than 65 lbs" do
          it "returns zero warmup sets" do
            sets = subject.prepare_sets_for(user, squat)
            warmup_sets = sets.select(&:warm_up?)
            expect(warmup_sets.length).to eql(0)
          end
        end

        describe "when the work set is between 65 lbs an 95 lbs" do
          it "returns two warmup sets" do
            workout = create(:workout, user: user, routine: routine_a)
            5.times { workout.train(squat, 65, repetitions: 5) }

            sets = subject.prepare_sets_for(user, squat)
            warmup_sets = sets.select(&:warm_up?)
            expect(warmup_sets.length).to eql(2)
            expect(warmup_sets.at(0).target_weight.to(:lbs)).to eql(45.lbs)
            expect(warmup_sets.at(0).target_repetitions).to eql(5)
            expect(warmup_sets.at(1).target_weight.to(:lbs)).to eql(45.lbs)
            expect(warmup_sets.at(1).target_repetitions).to eql(5)
          end
        end

        describe "when the work set is between 95 lbs and 105 lbs" do
          it "returns another warm up set" do
            workout = create(:workout, user: user, routine: routine_a)
            5.times { workout.train(squat, 95, repetitions: 5) }

            sets = subject.prepare_sets_for(user, squat)
            warmup_sets = sets.select(&:warm_up?)
            expect(warmup_sets.length).to eql(3)
            expect(warmup_sets.at(2).target_weight.to(:lbs)).to eql(65.lbs)
            expect(warmup_sets.at(2).target_repetitions).to eql(3)
          end
        end

        describe "when the work set is between 105 lbs and 125 lbs" do
          it "returns another warm up set" do
            workout = create(:workout, user: user, routine: routine_a)
            5.times { workout.train(squat, 105, repetitions: 5) }

            warmup_sets = subject.prepare_sets_for(user, squat).select(&:warm_up?)
            expect(warmup_sets.length).to eql(3)
            expect(warmup_sets.last.target_weight.to(:lbs)).to eql(75.lbs)
            expect(warmup_sets.last.target_repetitions).to eql(3)
          end
        end

        describe "when the work set is between 125 lbs and 135 lbs" do
          it "returns another warm up set" do
            workout = create(:workout, user: user, routine: routine_a)
            5.times { workout.train(squat, 125, repetitions: 5) }

            warmup_sets = subject.prepare_sets_for(user, squat).select(&:warm_up?)
            expect(warmup_sets.length).to eql(3)
            expect(warmup_sets.last.target_weight.to(:lbs)).to eql(85.lbs)
            expect(warmup_sets.last.target_repetitions).to eql(3)
          end
        end

        describe "when the work set is between 135 lbs and 150 lbs" do
          it "returns another warm up set" do
            workout = create(:workout, user: user, routine: routine_a)
            5.times { workout.train(squat, 135, repetitions: 5) }

            warmup_sets = subject.prepare_sets_for(user, squat).select(&:warm_up?)
            expect(warmup_sets.length).to eql(4)
            expect(warmup_sets.last.target_weight.to(:lbs)).to eql(115.lbs)
            expect(warmup_sets.last.target_repetitions).to eql(3)
          end
        end
      end
    end

    describe "deadlift" do
      let(:user) { build(:user) }

      it "returns 1 work set with 5 repetitions" do
        sets = subject.prepare_sets_for(user, deadlift)
        worksets = sets.select(&:work?)
        expect(worksets.length).to eql(1)
        expect(worksets.map(&:target_repetitions)).to match_array([5])
      end
    end

    describe "planks" do
      let(:user) { build(:user) }

      it "returns 3 set with 1 rep at 60 seconds" do
        sets = subject.prepare_sets_for(user, planks)
        worksets = sets.select(&:work?)
        expect(worksets.length).to eql(3)
        expect(worksets.map(&:target_repetitions)).to match_array([1,1,1])
        expect(worksets.map(&:target_weight).uniq).to match_array([0.lbs])
        expect(worksets.map(&:target_duration).uniq).to match_array([60])
      end
    end
  end
end
