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
        training_session = user.begin_workout(
          workout,
          DateTime.parse(row[:ZLOGDATE]),
          row[:ZBODYWEIGHT].to_f
        )

        workout_id = row[:Z_PK]
        db[:ZEXERCISESETS].where(ZWORKOUT: workout_id).each do |exercise_set_row|
          exercise = nil
          target_weight = nil

          exercise_id = exercise_set_row[:ZEXERCISETYPE]
          db[:ZEXERCISE].where(ZTYPE: exercise_id).each do |exercise_row|
            exercise = exercise_from(exercise_row)
          end

          weight_id = exercise_set_row[:ZWEIGHT]
          db[:ZWEIGHT].where(Z_PK: weight_id).each do |weight_row|
            target_weight = weight_row[:ZVAL]
          end

          sets = []
          1.upto(5) do |n|
            column = "ZSET#{n}".to_sym
            if exercise_set_row[column] && exercise_set_row[column] != -3
              sets << exercise_set_row[column]
            end
          end
          if exercise
            training_session.train(
              exercise,
              target_weight,
              sets
            )
          end
        end
      end
    end
  end

  private

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
