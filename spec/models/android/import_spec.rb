require "rails_helper"

describe Android::Import do
  include_context "stronglifts_program"
  subject { Android::Import.new(user, program) }
  let(:user) { create(:user) }

  describe "#import_from" do
    let(:directory) { Dir.mktmpdir }
    let(:backup_file) do
      Rails.root.join("spec", "fixtures", "backup.android.stronglifts")
    end

    before :each do
      `unzip #{backup_file} -d #{directory}`
    end

    after :each do
      FileUtils.remove_entry(directory)
    end

    it "imports each training session" do
      subject.import_from(directory)
      training_session = user.training_sessions.order(:occurred_at).first

      expect(training_session).to be_persisted
      expected_date = DateTime.new(2015, 03, 02, 16, 28, 26)
      expect(training_session.occurred_at.to_i).to eql(expected_date.to_i)
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

      expect(squat_session.target_weight).to eql(45.0)
      expect(squat_session.sets[0]).to eql("5")
      expect(squat_session.sets[1]).to eql("5")
      expect(squat_session.sets[2]).to eql("5")
      expect(squat_session.sets[3]).to eql("5")
      expect(squat_session.sets[4]).to eql("5")
    end

    it "imports the completed bench exercise" do
      subject.import_from(directory)

      training_session = user.training_sessions.order(:occurred_at).first
      bench_session = training_session.progress_for(bench_press)
      expect(bench_session.target_weight).to eql(65.0)
      expect(bench_session.sets[0]).to eql("5")
      expect(bench_session.sets[1]).to eql("5")
      expect(bench_session.sets[2]).to eql("5")
      expect(bench_session.sets[3]).to eql("5")
      expect(bench_session.sets[4]).to eql("5")
    end

    it "imports the completed barbell row exercise" do
      subject.import_from(directory)

      training_session = user.training_sessions.order(:occurred_at).first
      row_session = training_session.progress_for(barbell_row)
      expect(row_session.target_weight).to eql(65.0)
      expect(row_session.sets[0]).to eql("5")
      expect(row_session.sets[1]).to eql("5")
      expect(row_session.sets[2]).to eql("5")
      expect(row_session.sets[3]).to eql("5")
      expect(row_session.sets[4]).to eql("5")
    end

    it "excludes items that have already been imported" do
      subject.import_from(directory)
      subject.import_from(directory)
      expect(user.training_sessions.count).to eql(31)
    end
  end
end
