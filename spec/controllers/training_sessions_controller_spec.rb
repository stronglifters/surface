require "rails_helper"

describe TrainingSessionsController do
  let(:user) { create(:user) }

  before :each do
    http_login(user)
  end

  describe "#index" do
    include_context "stronglifts_program"
    let!(:training_session_a) { create(:training_session, user: user, workout: workout_a) }
    let!(:training_session_b) { create(:training_session, user: user, workout: workout_b) }

    it "loads all my training sessions" do
      get :index
      expect(assigns(:training_sessions)).to match_array([training_session_a, training_session_b])
    end

    it "allows iframes from google for the google drive popup" do
      get :index
      allowed_url = "ALLOW-FROM https://drive.google.com"
      expect(response.headers["X-Frame-Options"]).to eql(allowed_url)
    end
  end

  describe "#upload" do
    include_context "stronglifts_program"
    let(:backup_file) { fixture_file_upload("backup.android.stronglifts") }
    let(:translation) { I18n.translate("training_sessions.upload.success") }

    before :each do
      allow(UploadStrongliftsBackupJob).to receive(:perform_later)
    end

    it "uploads a new backup" do
      post :upload, backup: backup_file
      expect(UploadStrongliftsBackupJob).to have_received(:perform_later)
    end

    it "redirects to the dashboard" do
      post :upload, backup: backup_file
      expect(response).to redirect_to(dashboard_path)
    end

    it "displays a friendly message" do
      post :upload, backup: backup_file
      expect(flash[:notice]).to eql(translation)
    end

    context "when the file is not a backup file" do
      let(:unknown_file) { fixture_file_upload("unknown.file") }

      it "displays an error" do
        post :upload, backup: unknown_file
        translation = I18n.translate("training_sessions.upload.failure")
        expect(flash[:alert]).to eql(translation)
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  describe "#drive_upload" do
    let(:params) { {} }
    let(:success_message) do
      I18n.translate("training_sessions.drive_upload.success")
    end

    before :each do
      allow(DownloadFromDriveJob).to receive(:perform_later)
    end

    it "schedules a job to suck down the latest backup from google drive" do
      post :drive_upload, params
      expect(DownloadFromDriveJob).to have_received(:perform_later)
    end

    it "redirects to the dashboard" do
      post :drive_upload, params
      expect(response).to redirect_to(dashboard_path)
    end

    it "displays a success message" do
      post :drive_upload, params
      expect(flash[:notice]).to eql(success_message)
    end
  end
end
