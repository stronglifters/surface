require "rails_helper"

describe EmailProcessor do
  subject { EmailProcessor.new(email) }
  let(:email) { build(:email, :with_attachment) }

  context "with a csv attachment" do
    let(:backup_file) { double(process_later: true) }
    let(:user) { create(:user) }

    before :each do
      email.to.first[:token] = user.id
      email.from[:email] = user.email
    end

    it "imports the csv attachment" do
      allow(BackupFile).to receive(:new).
        with(user, email.attachments.first).
        and_return(backup_file)

      subject.process

      expect(backup_file).to have_received(:process_later).
        with(Program.stronglifts)
    end
  end
end
