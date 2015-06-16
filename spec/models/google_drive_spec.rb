require "rails_helper"

describe GoogleDrive do
  subject { GoogleDrive.new(user) }
  let(:user) { build(:user) }
  let(:referrer_domain) { 'https://www.stronglifters.com' }

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
      result = nil
      subject.download(params) do |backup_file|
        result = backup_file
      end
      expect(result).to_not be_nil
      expect(result.user).to eql(user)
      expect(result.backup_file.path).to end_with(filename)
    end
  end
end
