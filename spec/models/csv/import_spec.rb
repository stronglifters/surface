require "rails_helper"

describe Csv::Import do
  include_context "stronglifts_program"
  subject { Csv::Import.new(user, program) }
  let(:user) { create(:user) }

  describe "#can_parse?" do
    let(:directory) { Dir.mktmpdir }

    context "when the directory contains a csv export" do
      before :each do
        file_path = "#{directory}/spreadsheet-stronglifts-csv20151114-1138"
        FileUtils.touch(file_path)
      end

      it "returns true" do
        expect(subject.can_parse?(directory)).to be_truthy
      end
    end

    context "when the directory does not have csv export" do
      it "returns false" do
        expect(subject.can_parse?(directory)).to be_falsey
      end
    end
  end

  describe "#import_from" do
    let(:directory) { Dir.mktmpdir }
    let(:backup_file) do
      Rails.root.join("spec", "fixtures", "spreadsheet-stronglifts.csv")
    end

    before :each do
      `cp #{backup_file} #{directory}/spreadsheet-stronglifts.csv#{rand}`
    end

    after :each do
      FileUtils.remove_entry(directory)
    end

    it "imports each training session" do
      subject.import_from(directory)
      workout = user.workouts.order(:occurred_at).first

      expected_date = user.time_zone.local_to_utc(Time.utc(2015, 03, 02))
      expect(workout.occurred_at).to eql(expected_date)
      expect(workout.routine).to eql(routine_a)
      expect(workout.body_weight).to eql(205.0.lbs)
      expect(workout.sets.count).to eql(15)
      expect(
        workout.sets.map { |x| x.exercise.name }.uniq
      ).to match_array(["Squat", "Bench Press", "Barbell Row"])
    end

    it "imports the completed squat exercise" do
      subject.import_from(directory)

      workout = user.workouts.order(:occurred_at).first
      squat_session = workout.progress_for(squat)

      expect(squat_session.to_sets).to eql([5, 5, 5, 5, 5])
    end

    it "imports the completed bench exercise" do
      subject.import_from(directory)

      workout = user.workouts.order(:occurred_at).first
      bench_session = workout.progress_for(bench_press)
      expect(bench_session.sets.count).to eql(5)
      expect(bench_session.to_sets).to eql([5, 5, 5, 5, 5])
    end

    it "imports the completed barbell row exercise" do
      subject.import_from(directory)

      workout = user.workouts.order(:occurred_at).first
      progress = workout.progress_for(barbell_row)
      expect(progress.to_sets).to eql([5, 5, 5, 5, 5])
      sets = progress.sets.to_a
      expect(sets.at(0).target_weight).to eql(65.0)
      expect(sets.at(0).actual_repetitions).to eql(5)
      expect(sets.at(1).target_weight).to eql(65.0)
      expect(sets.at(1).actual_repetitions).to eql(5)
      expect(sets.at(2).target_weight).to eql(65.0)
      expect(sets.at(2).actual_repetitions).to eql(5)
      expect(sets.at(3).target_weight).to eql(65.0)
      expect(sets.at(3).actual_repetitions).to eql(5)
      expect(sets.at(4).target_weight).to eql(65.0)
      expect(sets.at(4).actual_repetitions).to eql(5)
    end

    it "excludes items that have already been imported" do
      subject.import_from(directory)
      subject.import_from(directory)
      expect(user.workouts.count).to eql(356)
    end
  end

  describe "#import" do
    it "imports dips" do
      row = '11/06/15,,,215,Squat,,265,5,5,5,,,Bench Press,,170,5,5,5,5,5,Barbell Row,,150,5,5,5,5,5,Weighted Dips,,12.5,5,5,5,Planks,,0,60,60,60,,,,,'.split(',')
      subject.import(row)

      workout = user.workouts.first
      progress = workout.progress_for(dips)
      expect(progress).to_not be_nil
      expect(progress.to_sets).to eql([5, 5, 5])
    end

    it "imports chinups" do
      row = '03/14/15,,,205,Squat,,85,5,5,5,5,5,Overhead Press,,70,5,5,5,5,5,Deadlift,,115,5,,,,,Chinups,,0,5,3,2,,,,,,,,,'.split(',')
      subject.import(row)

      workout = user.workouts.first
      progress = workout.progress_for(chinups)
      expect(progress).to_not be_nil
      expect(progress.to_sets).to eql([5, 3, 2])
      sets = progress.sets.to_a
      expect(sets.at(0).target_weight).to eql(0.0)
      expect(sets.at(0).target_repetitions).to eql(5)
      expect(sets.at(0).actual_repetitions).to eql(5)
      expect(sets.at(1).target_weight).to eql(0.0)
      expect(sets.at(1).target_repetitions).to eql(5)
      expect(sets.at(1).actual_repetitions).to eql(3)
      expect(sets.at(2).target_weight).to eql(0.0)
      expect(sets.at(2).target_repetitions).to eql(5)
      expect(sets.at(2).actual_repetitions).to eql(2)
    end

    it "imports the correct number of sets" do
      row = "06/05/16,,,231,Squat,,285,5,5,5,,,Overhead Press,,127,5,5,5,3,2,Deadlift,,305,5,,,,,Chinups,,0,5,4,4,Close Grip Bench Press,,110,5,5,5,,,,,".split(',')

      subject.import(row)
      workout = user.workouts.first
      progress = workout.progress_for(squat)
      expect(progress.sets.count).to eql(3)
      expect(progress.to_sets).to eql([5, 5, 5])

      progress = workout.progress_for(deadlift)
      expect(progress.sets.count).to eql(1)
      expect(progress.to_sets).to eql([5])
    end
  end
end
