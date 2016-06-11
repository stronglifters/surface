class Ios::Import
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
      db[:ZBASEWORKOUT].each do |row|
        workout_name = row[:ZTYPE] == 1 ? "A" : "B"
        workout = program.workouts.find_by(name: workout_name)
        time = row[:ZDATE].to_s.split(' ')
        date_string = "#{row[:ZLOGDATE]} #{time[1]} #{time[2]}"
        occurred_at = DateTime.parse(date_string)
        body_weight = row[:ZBODYWEIGHT].to_f
        training_session = user.begin_workout(workout, occurred_at, body_weight)

        db[:ZEXERCISESETS].where(ZWORKOUT: row[:Z_PK]).
          each do |exercise_set_row|
          db[:ZEXERCISE].where(ZTYPE: exercise_set_row[:ZEXERCISETYPE]).
            each do |exercise_row|
            exercise = exercise_from(exercise_row)
            if exercise
              db[:ZWEIGHT].
                where(Z_PK: exercise_set_row[:ZWEIGHT]).each do |weight_row|
                target_weight = weight_row[:ZVAL]
                sets_from(exercise_set_row).each_with_index do |reps, set|
                  training_session.train(exercise, target_weight, repetitions: reps, set: set)
                end
              end
            end
          end
        end
      end
    end
  end

  private

  def sets_from(row)
    (1..5).inject([]) do |memo, n|
      column = "ZSET#{n}".to_sym
      memo << row[column] if row[column] && row[column] != -3
    end || []
  end

  def database_file(directory)
    File.join(directory, "SLDB.sqlite")
  end

  def database(directory)
    yield Sequel.sqlite(database_file(directory))
  end

  def exercise_from(exercise_row)
    mapping = {
      1 => "Squat",
      2 => "Bench Press",
      3 => "Barbell Row",
      4 => "Overhead Press",
      5 => "Deadlift",
    }

    program.exercises.find_by(name: mapping[exercise_row[:ZTYPE]])
  end
end
