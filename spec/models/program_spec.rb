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

      it 'returns 5 sets of 5 repetitions' do
        sets = subject.prepare_sets_for(user, squat)
        expect(sets.length).to eql(5)
        expect(sets.map(&:target_repetitions)).to match_array([5, 5, 5, 5, 5])
      end

      it 'returns the correct exercise for each set' do
        sets = subject.prepare_sets_for(user, squat)
        expect(sets.map(&:exercise).uniq).to match_array([squat])
      end

      it 'returns 45 lbs for the first workout' do
        sets = subject.prepare_sets_for(user, squat)
        expect(sets.map(&:target_weight).uniq).to match_array([45.lbs])
      end

      it 'returns 50 lbs for the second workout' do
        workout = create(:workout, user: user, routine: routine_a)
        5.times { workout.train(squat, 45, repetitions: 5) }

        sets = subject.prepare_sets_for(user, squat)
        expect(sets.map(&:target_weight).uniq).to match_array([50.lbs])
      end

      it 'returns the same weight after a failed workout' do
        workout = create(:workout, user: user, routine: routine_a)
        5.times { |n| workout.train(squat, 45, repetitions: n) }

        sets = subject.prepare_sets_for(user, squat)
        expect(sets.map(&:target_weight).uniq).to match_array([45.lbs])
      end
    end
  end
end
