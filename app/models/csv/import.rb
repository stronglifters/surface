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
      csv_rows_from(database_file(directory)) do |row|
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
      exercise_row.sets.compact.each_with_index do |completed_reps, index|
        next if completed_reps.blank?
        training_session.train(
          exercise,
          exercise_row.weight_lb,
          repetitions: completed_reps,
          set: index
        )
      end
    end
  end

  private

  def database_file(dir)
    Dir.glob("#{dir}/*csv*").first
  end

  def csv_rows_from(file)
    previous = nil
    ::CSV.foreach(file).drop(1).each do |row|
      duplicate = previous.present? && row == previous
      next if duplicate
      yield row
      previous = row
    end
  end
end
