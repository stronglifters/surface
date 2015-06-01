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
      db.execute("SELECT * FROM ZBASEWORKOUT") do |row|
        workout_name = row[5] == 1 ? "A" : "B"
        workout = program.workouts.find_by(name: workout_name)
        training_session = user.begin_workout(workout, DateTime.parse(row[8]), row[7].to_f)

        workout_id = row[0]
        db.execute("SELECT * FROM ZEXERCISESETS WHERE ZWORKOUT = '#{workout_id}';") do |exercise_set_row|
          exercise = nil
          target_weight = nil

          exercise_id = exercise_set_row[4]
          db.execute("SELECT * FROM ZEXERCISE WHERE ZTYPE = '#{exercise_id}';") do |exercise_row|
            exercise = exercise_from(exercise_row)
          end

          weight_id = exercise_set_row[13]
          db.execute("SELECT * FROM ZWEIGHT where Z_PK = '#{weight_id}'") do |weight_row|
            target_weight = weight_row[6]
          end

          sets = []
          6.upto(10) do |n|
            if exercise_set_row[n] && exercise_set_row[n] != -3
              sets << exercise_set_row[n]
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
    yield SQLite3::Database.new(database_file(directory))
  end

  def exercise_from(exercise_row)
    mapping = {
      1 => "Squat",
      2 => "Bench Press",
      3 => "Barbell Row",
      4 => "Overhead Press",
      5 => "Deadlift",
    }

    program.exercises.find_by(name: mapping[exercise_row[4]])
  end
end
