class Android::Import
  attr_reader :user, :program

  def initialize(user, program)
    @user = user
    @program = program
  end

  def can_parse?(directory)
    File.exist?(database_file(directory))
  end

  def import_from(directory)
    database(directory) do |db|
      ActiveRecord::Base.transaction do
        db[:workouts].each do |row|
          import(row)
        end
      end
    end
  end

  private

  def import(row)
    create_workout_from(map_from(row))
  end

  def database_file(dir)
    "#{dir}/stronglifts.db"
  end

  def database(directory)
    yield Sequel.sqlite(database_file(directory))
  end

  def create_workout_from(workout_row)
    training_session_for(workout_row) do |training_session, workout|
      workout.exercise_workouts.each_with_index do |exercise_workout, index|
        exercise_row = workout_row.exercises[index]
        next if exercise_row.nil?
        sets_from(exercise_workout, exercise_row).each_with_index do |reps, set|
          training_session.train(
            exercise_workout.exercise,
            exercise_row["warmup"]["targetWeight"],
            repetitions: reps,
            set: set,
          )
        end
      end
    end
  end

  def training_session_for(workout_row)
    workout = program.workouts.find_by(name: workout_row.workout)
    user.begin_workout(
      workout,
      workout_row.date,
      workout_row.body_weight.to_f
    ).tap do |training_session|
      yield training_session, workout
      training_session
    end
  end

  def sets_from(exercise_workout, exercise_row)
    sets = []
    1.upto(exercise_workout.sets).each do |n|
      if exercise_row["set#{n}"].to_i > 0
        sets << exercise_row["set#{n}"]
      else
        sets << 0
      end
    end
    sets
  end

  def map_from(row)
    Android::Workout.new(
      id: row[:id],
      date: user.time_zone.local_to_utc(row[:date]),
      workout: row[:workout],
      exercise_1: JSON.parse(row[:e1]),
      exercise_2: JSON.parse(row[:e2]),
      exercise_3: JSON.parse(row[:e3]),
      note: row[:note],
      body_weight: row[:bodyWeight],
      arm_work: row[:armWork].present? ? JSON.parse(row[:armWork]) : nil,
      temp: row[:temp]
    )
  end
end
