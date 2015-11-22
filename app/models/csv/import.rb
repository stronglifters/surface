require "csv"

class Csv::Import
  attr_reader :user, :program

  def initialize(user, program)
    @user = user
    @program = program
  end

  def can_parse?(directory)
    database_file(directory).present?
  end

  def import_from(directory)
    ActiveRecord::Base.transaction do
      ::CSV.foreach(database_file(directory)).drop(1).each do |row|
        import(row)
      end
    end
  end

  def import(row)
    workout_row = Csv::Workout.map_from(row, user)

    workout = program.workouts.find_by(name: workout_row.workout)
    training_session = user.begin_workout(
      workout,
      workout_row.date,
      workout_row.body_weight_lb
    )
    workout.exercises.each do |exercise|
      exercise_row = workout_row.find(exercise)
      next if exercise_row.nil?
      training_session.train(exercise, exercise_row.weight_lb, exercise_row.sets)
    end
  end

  private

  def database_file(dir)
    Dir.glob("#{dir}/spreadsheet-stronglifts*csv*").first
  end
end
