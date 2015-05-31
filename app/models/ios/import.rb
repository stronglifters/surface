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
        Rails.logger.debug [ "workout_id", workout_id].inspect
        db.execute("SELECT * FROM ZEXERCISESETS WHERE ZWORKOUT = '#{workout_id}';") do |exercise_set_row|
          Rails.logger.debug ["exercise set", exercise_set_row].inspect

          exercise = nil
          target_weight = nil

          exercise_id = exercise_set_row[4]
          Rails.logger.debug ["exercise id", exercise_id].inspect
          db.execute("SELECT * FROM ZEXERCISE WHERE ZTYPE = '#{exercise_id}';") do |exercise_row|
            Rails.logger.debug ["exercise row", exercise_row].inspect
            exercise = exercise_from(exercise_row)
          end

          weight_id = exercise_set_row[13]
          Rails.logger.debug ["weight id", weight_id].inspect
          db.execute("SELECT * FROM ZWEIGHT where Z_PK = '#{weight_id}'") do |weight_row|
            Rails.logger.debug ["weight row", weight_row].inspect
            target_weight = weight_row[6]
          end

          sets = [
            row[6],
            row[7],
            row[8],
            row[9] == -3 ? nil : row[9],
            row[10] == -3 ? nil : row[10]
          ]
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
