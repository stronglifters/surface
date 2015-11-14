require "csv"

class Csv::Import
  attr_reader :user, :program

  def initialize(user, program)
    @user = user
    @program = program
  end

  def can_parse?(directory)
    File.exist?(database_file(directory))
  end

  def import_from(directory)
    ActiveRecord::Base.transaction do
      ::CSV.foreach(database_file(directory)).drop(1).each do |row|
        import(row)
      end
    end
  end

  private

  def database_file(dir)
    "#{dir}/spreadsheet-stronglifts.csv"
  end

  def import(row)
    workout_row = Csv::Workout.map_from(row, user)

    workout = program.workouts.find_by(name: workout_row.workout)
    training_session = user.begin_workout(
      workout,
      workout_row.date,
      workout_row.body_weight_lb.to_f)
    training_session.exercise_sessions.destroy_all
    workout.exercise_workouts.each do |exercise_workout|
      row = workout_row.exercises.detect do |x|
        x.name.downcase == exercise_workout.exercise.name.downcase
      end
      training_session.train(
        exercise_workout.exercise,
        row.weight_lb,
        row.sets
      )
    end
  end
end
