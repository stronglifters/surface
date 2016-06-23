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

  describe "#new" do
    include_context "stronglifts_program"

    it "loads the next workout in the program" do
      create(:training_session, user: user, workout: workout_a)

      get :new

      expect(assigns(:workout)).to eql(workout_b)
    end

    it "loads the first workout in the program" do
      get :new

      expect(assigns(:workout)).to eql(workout_a)
    end
  end

  describe "#create" do
    include_context "stronglifts_program"
    let(:body_weight) { rand(250.0) }

    it "creates a new training session" do
      post :create, training_session: {
        workout_id: workout_b.id,
        body_weight: body_weight
      }
      expect(user.reload.training_sessions.count).to eql(1)
      expect(user.last_workout).to eql(workout_b)
      expect(user.training_sessions.last.body_weight).to eql(body_weight.to_f)
      expect(response).to redirect_to(edit_training_session_path(user.training_sessions.last))
    end

    it 'creates the training session with the selected exercises' do
      post :create, training_session: {
        workout_id: workout_b.id,
        body_weight: body_weight,
        exercise_sessions_attributes: [
          {
            exercise_workout_id: workout_b.exercise_workouts.first.id,
            #target_repetitions: 4,
            #target_sets: 3,
            #target_weight: 275.0,
          }
        ]
      }

      expect(user.reload.training_sessions.count).to eql(1)
      expect(user.last_workout).to eql(workout_b)
      training_session = user.training_sessions.last
      expect(training_session.body_weight).to eql(body_weight.to_f)
      expect(training_session.exercise_sessions.count).to eql(1)
      exercise_session = training_session.exercise_sessions.first
      #expect(exercise_session.target_sets).to eql(3)
      #expect(exercise_session.target_repetitions).to eql(4)
      #expect(exercise_session.target_weight).to eql(275.0)
      expect(response).to redirect_to(edit_training_session_path(user.training_sessions.last))
    end
  end

  describe "#edit" do
    let(:training_session) { create(:training_session, user: user) }

    it "loads the training session" do
      get :edit, id: training_session.id
      expect(assigns(:training_session)).to eql(training_session)
    end
  end

  describe "#update" do
    include_context "stronglifts_program"
    let(:training_session) { create(:training_session, user: user, workout: workout_a) }

    it "records the exercise" do
      xhr :patch, :update, id: training_session.id, training_session: {
        exercise_id: squat.id,
        weight: 315,
        sets: [5, 5, 5],
      }
      expect(training_session.exercises).to include(squat)
      expect(training_session.progress_for(squat).sets.first.target_weight).to eql(315.to_f)
      expect(training_session.progress_for(squat).to_sets).to eql([5, 5, 5])
    end
  end
end
