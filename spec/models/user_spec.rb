require "rails_helper"

describe User do
  describe "#create" do
    it "saves a new user to the database" do
      user = create(:user)

      saved_user = User.find(user.id)
      expect(saved_user.username).to eql(user.username)
      expect(saved_user.email).to eql(user.email)
      expect(saved_user.password).to be_nil
    end
  end

  describe "validations" do
    context "username" do
      it "is invalid when the username is missing" do
        user = User.new(username: nil)
        expect(user).to_not be_valid
        expect(user.errors[:username]).to_not be_empty
      end

      it "is invalid if invalid characters are in the username" do
        user = User.new(username: "$()")
        expect(user).to_not be_valid
        expect(user.errors[:username]).to_not be_empty
      end

      it "is invalid if the username is already taken" do
        create(:user, username: "blah", email: "blah@example.com")
        user = build(:user, username: "blah", email: "blahblah@example.com")
        expect(user).to_not be_valid
        expect(user.errors[:username]).to_not be_empty
      end
    end

    describe "#email" do
      it "is invalid when the email is missing" do
        user = User.new(email: nil)
        expect(user).to_not be_valid
        expect(user.errors[:email]).to_not be_empty
      end

      it "is invalid when the email is not in the correct format" do
        user = User.new(email: "blah")
        expect(user).to_not be_valid
        expect(user.errors[:email]).to_not be_empty
      end

      it "is invalid if the email address is already registered" do
        create(:user, username: "blahblah", email: "blah@example.com")
        second_user = build(:user, username: "blah", email: "blah@example.com")
        expect(second_user).to_not be_valid
        expect(second_user.errors[:email]).to_not be_empty
      end
    end

    describe "terms_and_conditions" do
      it "is invalid if terms and conditions is unchecked" do
        user = User.new(terms_and_conditions: false)
        expect(user).to_not be_valid
        expect(user.errors[:terms_and_conditions]).to_not be_empty
      end
    end

    it "is valid when it is" do
      user = User.new(
        username: "coolio",
        email: "notblank@example.com",
        password: "legit",
        terms_and_conditions: "1")
      expect(user).to be_valid
    end
  end

  describe "USERNAME_REGEX" do
    it "does not match" do
      expect(User::USERNAME_REGEX).to_not match("$username")
      expect(User::USERNAME_REGEX).to_not match("!username")
      expect(User::USERNAME_REGEX).to_not match("@username")
    end

    it "matches" do
      expect(User::USERNAME_REGEX).to match("username")
      expect(User::USERNAME_REGEX).to match("user.name")
      expect(User::USERNAME_REGEX).to match("user_name")
      expect(User::USERNAME_REGEX).to match("user-name")
      expect(User::USERNAME_REGEX).to match("username1")
    end
  end

  describe "#authenticate" do
    context "when credentials are correct" do
      it "returns true" do
        user = create(:user, password: "password", password_confirmation: "password")
        expect(User.authenticate(user.email, "password")).to eql(user)
      end
    end

    context "when the email is not registered" do
      it "returns nil" do
        expect(User.authenticate("sofake@noteven.com", "password")).to be_nil
      end
    end

    context "when the username is not registered" do
      it "returns nil" do
        expect(User.authenticate("sofake", "password")).to be_nil
      end
    end
  end

  describe "#to_param" do
    it "returns the username as the uniq identifier" do
      user = build(:user)
      expect(user.to_param).to eql(user.username)
    end
  end

  describe "#personal_record" do
    include_context "stronglifts_program"
    let(:user) { create(:user) }
    let(:exercise_workout) { workout_a.exercise_workouts.first }
    let(:exercise) { exercise_workout.exercise }

    before :each do
      training_session = user.training_sessions.create!(
        workout: workout_a,
        occurred_at: DateTime.now.utc
      )
      1.upto(5) do |n|
        training_session.exercise_sessions.create!(
          target_weight: (200 + n),
          exercise_workout: exercise_workout,
          sets: [5, 5, 5, 5, 5]
        )
      end
    end

    it "returns the users maximum amount of weight lifted" do
      expect(user.personal_record(exercise)).to eql(205.0)
    end
  end

  describe "#begin_workout" do
    subject { create(:user) }
    let(:workout) { create(:workout) }
    let(:today) { DateTime.now }

    it "creates a new training session" do
      result = subject.begin_workout(workout, today, 200)
      expect(result).to be_persisted
      expect(subject.training_sessions.count).to eql(1)
      expect(subject.training_sessions.first).to eql(result)
      expect(result.workout).to eql(workout)
      expect(result.occurred_at).to eql(today.utc)
      expect(result.body_weight).to eql(200.0)
    end

    it "returns the existing workout for that day" do
      result = subject.begin_workout(workout, today, 200)
      expect(subject.begin_workout(workout, today, 200)).to eql(result)
    end

    it "returns different sessions for different days" do
      todays_result = subject.begin_workout(workout, today, 200)
      tomorrows_result = subject.begin_workout(workout, DateTime.tomorrow, 200)
      expect(todays_result).to_not eql(tomorrows_result)
    end
  end

  describe "#google_drive" do
    it "returns the users google drive" do
      result = subject.google_drive
      expect(result).to be_instance_of(GoogleDrive)
      expect(result.user).to eql(subject)
    end
  end

  describe "when destroying a training session" do
    include_context "stronglifts_program"
    subject { create(:user) }

    it "removes all the associations" do
      training_session = subject.begin_workout(workout_a, Date.today, 200)
      training_session.train(squat, 200, [5, 5, 5, 5, 5])

      subject.training_sessions.destroy_all

      expect(TrainingSession.all).to be_empty
      expect(ExerciseSession.all).to be_empty
    end
  end
end
