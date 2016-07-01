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

    it "lowercases the username" do
      user = create(:user, username: "UpCASE")
      expect(user.reload.username).to eql("upcase")
    end

    it "lowercases the email" do
      user = create(:user, email: FFaker::Internet.email.upcase)
      expect(user.reload.email).to eql(user.email.downcase)
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


  describe "#to_param" do
    it "returns the username as the uniq identifier" do
      user = build(:user)
      expect(user.to_param).to eql(user.username)
    end
  end

  describe "#personal_record_for" do
    include_context "stronglifts_program"
    let(:user) { create(:user) }
    let(:recommendation) { routine_a.recommendations.first }
    let(:exercise) { recommendation.exercise }

    before :each do
      workout = user.workouts.create!(
        routine: routine_a,
        occurred_at: DateTime.now.utc
      )
      workout.train(squat, 201, repetitions: recommendation.repetitions)
      workout.train(squat, 202, repetitions: recommendation.repetitions)
      workout.train(squat, 210, repetitions: recommendation.repetitions - 1)
      workout.train(squat, 204, repetitions: recommendation.repetitions)
      workout.train(squat, 205, repetitions: recommendation.repetitions)
    end

    it "returns the users maximum amount of weight lifted" do
      expect(user.personal_record_for(exercise)).to eql(205.0)
    end
  end

  describe "#begin_workout" do
    subject { create(:user) }
    let(:routine) { create(:routine) }
    let(:today) { DateTime.now }

    it "creates a new training session" do
      result = subject.begin_workout(routine, today, 200)
      expect(result).to be_persisted
      expect(subject.workouts.count).to eql(1)
      expect(subject.workouts.first).to eql(result)
      expect(result.routine).to eql(routine)
      expect(result.occurred_at).to eql(today.utc)
      expect(result.body_weight).to eql(200.lbs)
    end

    it "returns the existing workout for that day" do
      result = subject.begin_workout(routine, today, 200)
      expect(subject.begin_workout(routine, today, 200)).to eql(result)
    end

    it "returns different sessions for different days" do
      todays_result = subject.begin_workout(routine, today, 200)
      tomorrows_result = subject.begin_workout(routine, DateTime.tomorrow, 200)
      expect(todays_result).to_not eql(tomorrows_result)
    end
  end

  describe "when destroying a training session" do
    include_context "stronglifts_program"
    subject { create(:user) }

    it "removes all the associations" do
      workout = subject.begin_workout(routine_a, Date.today, 200)
      workout.train(squat, 200, repetitions: 5)
      workout.train(squat, 200, repetitions: 5)
      workout.train(squat, 200, repetitions: 5)
      workout.train(squat, 200, repetitions: 5)
      workout.train(squat, 200, repetitions: 5)

      subject.workouts.destroy_all

      expect(Workout.all).to be_empty
      expect(ExerciseSet.all).to be_empty
    end
  end

  describe "#profile" do
    let(:user) { create(:user) }

    it "creates a new profile" do
      expect(user.profile).to be_present
      expect(user.profile.other?).to be_truthy
      expect(user.profile.social_tolerance).to be_nil
    end
  end

  describe "#login" do
    context "when credentials are correct" do
      it "returns true" do
        user = create(:user, password: "password", password_confirmation: "password")
        result = User.login(user.email.upcase, "password")
        expect(result).to be_instance_of(UserSession)
        expect(result.user).to eql(user)
      end

      it "is case in-sensitive for username" do
        user = create(:user, username: "upcase", password: "password", password_confirmation: "password")
        result = User.login("UPcase", "password")
        expect(result).to be_instance_of(UserSession)
        expect(result.user).to eql(user)
      end
    end

    context "when the email is not registered" do
      it { expect(User.login("sofake@noteven.com", "password")).to be_falsey }
    end

    context "when the username is not registered" do
      it { expect(User.login("sofake", "password")).to be_falsey }
    end
  end

  describe "#add_to_inbox" do
    include_context "stronglifts_program"
    subject { create(:user) }
    let(:email) { build(:email, :with_attachment) }

    it "records the email" do
      subject.add_to_inbox(email)
      expect(subject.received_emails.count).to eql(1)
      received_email = subject.received_emails.first
      expect(received_email.to.map(&:symbolize_keys)).to match_array(email.to)
      expect(received_email.from.symbolize_keys).to eql(email.from)
      expect(received_email.subject).to eql(email.subject)
      expect(received_email.body).to eql(email.body)
    end
  end

  describe "#next_workout_for" do
    subject { create(:user) }
    let(:routine) { create(:routine) }
    let(:body_weight) { rand(300) }

    it "includes the body weight from the previous workout" do
      create(:workout, user: subject, body_weight: body_weight)

      workout = subject.next_workout_for(routine)
      expect(workout.body_weight).to eql(body_weight)
    end

    it "uses the correct routine" do
      workout = subject.next_workout_for(routine)
      expect(workout.routine).to eql(routine)
    end

    it "prepares the correct number of sets" do
      squat = create(:exercise)
      routine.add_exercise(squat, sets: 3)
      workout = subject.next_workout_for(routine)
      expect(workout.exercise_sets.length).to eql(3)
    end
  end

  describe "#next_routine" do
    include_context "stronglifts_program"
    subject { create(:user) }

    it "routines the next workout" do
      create(:workout, routine: routine_a, user: subject)
      expect(subject.next_routine).to eql(routine_b)
    end

    it "returns the first routine in the program" do
      expect(subject.next_routine).to eql(routine_a)
    end
  end

  describe "#last_workout" do
    include_context "stronglifts_program"
    subject { create(:user) }

    it "returns the last workout" do
      workout = create(:workout, user: subject, routine: routine_a)
      expect(subject.last_workout).to eql(workout)
    end

    it "returns the last workout that included a specific exercise" do
      deadlift_workout = create(:workout, user: subject, routine: routine_b)
      deadlift_workout.train(deadlift, 315.lbs, repetitions: 5)
      bench_workout = create(:workout, user: subject, routine: routine_a)
      bench_workout.train(bench_press, 195.lbs, repetitions: 5)

      expect(subject.last_workout(deadlift)).to eql(deadlift_workout)
    end

    it "returns nil when no workouts have been completed" do
      expect(subject.last_workout).to be_nil
    end

    it "returns nil when the exercise has not been performed" do
      bench_workout = create(:workout, user: subject, routine: routine_a)
      bench_workout.train(bench_press, 195.lbs, repetitions: 5)

      expect(subject.last_workout(deadlift)).to be_nil
    end
  end
end
