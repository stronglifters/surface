require "rails_helper"

RSpec.describe DownloadFromDriveJob, type: :job do
  describe "#perform" do
    let(:user) { build(:user) }
    let(:params) { {} }
    let(:backup_file) { double(process_later: true) }
    let(:drive) { instance_double(GoogleDrive) }

    it "downloads the file for further processing" do
      allow(user).to receive(:google_drive).and_return(drive)
      allow(drive).to receive(:download).with(params).and_yield(backup_file)
      subject.perform(user, params)
      expect(backup_file).to have_received(:process_later).with(Program.stronglifts)
    end
  end
end
