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
      training_session = user.training_sessions.order(:occurred_at).first

      expected_date = user.time_zone.local_to_utc(Time.utc(2015, 03, 02))
      expect(training_session.occurred_at).to eql(expected_date)
      expect(training_session.workout).to eql(workout_a)
      expect(training_session.body_weight).to eql(205.0)
      expect(training_session.exercise_sessions.count).to eql(3)
      expect(
        training_session.exercise_sessions.map { |x| x.exercise.name }
      ).to match_array(["Squat", "Bench Press", "Barbell Row"])
    end

    it "imports the completed squat exercise" do
      subject.import_from(directory)

      training_session = user.training_sessions.order(:occurred_at).first
      squat_session = training_session.progress_for(squat)

      expect(squat_session.to_sets).to eql([5, 5, 5, 5, 5])
    end

    it "imports the completed bench exercise" do
      subject.import_from(directory)

      training_session = user.training_sessions.order(:occurred_at).first
      bench_session = training_session.progress_for(bench_press)
      expect(bench_session.sets.count).to eql(5)
      expect(bench_session.to_sets).to eql([5, 5, 5, 5, 5])
    end

    it "imports the completed barbell row exercise" do
      subject.import_from(directory)

      training_session = user.training_sessions.order(:occurred_at).first
      row_session = training_session.progress_for(barbell_row)
      expect(row_session.to_sets).to eql([5, 5, 5, 5, 5])
      expect(row_session.sets.at(0).target_weight).to eql(65.0)
      expect(row_session.sets.at(0).actual_repetitions).to eql(5)
      expect(row_session.sets.at(1).target_weight).to eql(65.0)
      expect(row_session.sets.at(1).actual_repetitions).to eql(5)
      expect(row_session.sets.at(2).target_weight).to eql(65.0)
      expect(row_session.sets.at(2).actual_repetitions).to eql(5)
      expect(row_session.sets.at(3).target_weight).to eql(65.0)
      expect(row_session.sets.at(3).actual_repetitions).to eql(5)
      expect(row_session.sets.at(4).target_weight).to eql(65.0)
      expect(row_session.sets.at(4).actual_repetitions).to eql(5)
    end

    it "excludes items that have already been imported" do
      subject.import_from(directory)
      subject.import_from(directory)
      expect(user.training_sessions.count).to eql(168)
    end
  end

  describe "#import" do
    it "imports dips" do
      row = ["06/11/15", "", "A", "97.4", "215", "Squat", "120", "265", "5", "5", "5", nil, nil, "Bench press", "77.5", "170", "5", "5", "5", "5", "5", "Barbell row", "67.5", "150", "5", "5", "5", "5", "5", "Dips", "5", "12.5", "5", "5", "5"]
      subject.import(row)

      training_session = user.training_sessions.first
      session = training_session.progress_for(dips)
      expect(session).to_not be_nil
      expect(session.to_sets).to eql([5, 5, 5])
    end

    it "imports chinups" do
      row = ["14/03/15", "", "B", "92.87", "205", "Squat", "37.5", "85", "5", "5", "5", "5", "5", "Overhead press", "32.5", "70", "5", "5", "5", "5", "5", "Deadlift", "52.5", "115", "5", nil, nil, nil, nil, "Chinups", "0", "0", "5", "3", "2"]
      subject.import(row)

      training_session = user.training_sessions.first
      session = training_session.progress_for(chinups)
      expect(session).to_not be_nil
      expect(session.to_sets).to eql([5, 3, 2])
      expect(session.sets.at(0).target_weight).to eql(0.0)
      expect(session.sets.at(0).target_repetitions).to eql(5)
      expect(session.sets.at(0).actual_repetitions).to eql(5)
      expect(session.sets.at(1).target_weight).to eql(0.0)
      expect(session.sets.at(1).target_repetitions).to eql(5)
      expect(session.sets.at(1).actual_repetitions).to eql(3)
      expect(session.sets.at(2).target_weight).to eql(0.0)
      expect(session.sets.at(2).target_repetitions).to eql(5)
      expect(session.sets.at(2).actual_repetitions).to eql(2)
    end
  end
end
