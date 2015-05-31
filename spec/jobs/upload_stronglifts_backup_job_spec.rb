require "rails_helper"

describe UploadStrongliftsBackupJob, type: :job do
  include_context "stronglifts_program"
  let(:user) { create(:user) }

  describe "#perform" do
    context "android backup" do
      let(:backup_file) do
        Rails.root.join("spec", "fixtures", "backup.android.stronglifts").to_s
      end

      it "adds each workout to the list of training sessions for the user" do
        subject.perform(user, backup_file, program)

        expect(user.training_sessions.count).to eql(31)
      end
    end

    context "ios backup" do
      let(:backup_file) do
        Rails.root.join("spec", "fixtures", "backup.ios.stronglifts").to_s
      end

      it "adds each workout to the list of training sessions for the user" do
        subject.perform(user, backup_file, program)

        expect(user.training_sessions.count).to eql(9)
      end
    end
  end
end
