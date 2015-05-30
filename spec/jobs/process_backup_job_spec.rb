require 'rails_helper'

describe ProcessBackupJob, type: :job do
  include_context "stronglifts_program"
  let(:user) { create(:user) }

  describe "#perform" do
    context "android backup" do
      let(:backup_file) { Rails.root.join("spec", "fixtures", "android-backup.stronglifts").to_s }

      it "adds each workout to the list of training sessions for the user" do
        subject.perform(user, backup_file, program)

        expect(user.training_sessions.count).to eql(31)
      end
    end
  end
end
