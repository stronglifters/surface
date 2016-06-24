require "rails_helper"

describe BackupFile do
  let(:user) { build(:user) }

  def fixture_file(name)
    Rack::Test::UploadedFile.new(Rails.root.join("spec", "fixtures", name))
  end

  describe "#valid?" do
    it "returns true for csv exports" do
      csv_export = fixture_file("spreadsheet-stronglifts.csv")
      subject = BackupFile.new(user, csv_export)
      expect(subject).to be_valid
    end

    it "returns false" do
      subject = BackupFile.new(user, fixture_file("unknown.file"))
      expect(subject).to_not be_valid
    end
  end

  describe "#process_later" do
    let(:program) { build(:program) }

    it "creates a job to process later" do
      allow(UploadStrongliftsBackupJob).to receive(:perform_later)
      subject = BackupFile.new(user, fixture_file("spreadsheet-stronglifts.csv"))
      subject.process_later(program)
      expect(UploadStrongliftsBackupJob).to have_received(:perform_later)
    end
  end
end
