require "rails_helper"

describe UploadStrongliftsBackupJob, type: :job do
  include_context "stronglifts_program"
  let(:user) { create(:user) }

  describe "#perform" do
    context "csv export" do
      let(:backup_file) do
        Rails.root.join("spec", "fixtures", "spreadsheet-stronglifts.csv").to_s
      end

      it "adds each workout to the list of training sessions for the user" do
        subject.perform(user, backup_file, program)

        expect(user.training_sessions.count).to eql(168)
      end
    end

    context "unknown filetype" do
      let(:mailer) { double(deliver_later: true) }
      let(:unknown_file) { __FILE__ }

      it "does not raise an error" do
        expect(-> { subject.perform(user, unknown_file, program) }).
          to_not raise_error
      end
    end
  end
end
