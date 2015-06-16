require "rails_helper"

describe GoogleDrive do
  subject { GoogleDrive.new(user) }
  let(:user) { build(:user) }

  describe "#download" do
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

    it "downloads the specified google drive file" do
      result = subject.download(params)
      expect(result.user).to eql(user)
      expect(result.backup_file.path).to end_with(filename)
    end
  end
end
