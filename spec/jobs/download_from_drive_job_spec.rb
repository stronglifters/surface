require "rails_helper"

RSpec.describe DownloadFromDriveJob, type: :job do
  describe "#perform" do
    let(:user) { build(:user) }
    let(:params) do
      {
        accessToken: access_token,
        data: {
          title: filename,
          downloadUrl: 'https://www.stronglifters.com/'
        },
      }
    end
    let(:filename) { "#{FFaker::Internet.user_name}.html" }
    let(:access_token) { FFaker::Internet.user_name }
    let(:backup_file) { double(process_later: true) }

    it "downloads the file for further processing" do
      allow(BackupFile).to receive(:new).and_return(backup_file)
      subject.perform(user, params)
      expect(backup_file).to have_received(:process_later).with(Program.stronglifts)
    end
  end
end
