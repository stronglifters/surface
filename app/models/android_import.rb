class AndroidImport
  attr_reader :user, :program

  def initialize(user, program)
    @user = user
    @program = program
  end

  def import(row)
    create_workout_from(map_from(row), program)
  end

  private

  def create_workout_from(workout_row, program)
    ActiveRecord::Base.transaction do
      workout = program.workouts.find_by(name: workout_row.workout)
      session = user.begin_workout(workout, workout_row.date, workout_row.body_weight.to_f)

      session.exercise_sessions.destroy_all
      workout.exercise_workouts.each_with_index do |exercise_workout, index|
        exercise_row = workout_row.exercises[index]
        sets = []
        1.upto(exercise_workout.sets).each do |n|
          if exercise_row["set#{n}"].to_i > 0
            sets << exercise_row["set#{n}"]
          else
            sets << 0
          end
        end

        session.train(
          exercise_workout.exercise,
          exercise_row["warmup"]["targetWeight"],
          sets
        )
      end
      session
    end
  end

  def map_from(row)
    WorkoutRow.new(
      id: row[0],
      date: DateTime.parse(row[1]),
      workout: row[2],
      exercise_1: JSON.parse(row[3]),
      exercise_2: JSON.parse(row[4]),
      exercise_3: JSON.parse(row[5]),
      note: row[6],
      body_weight: row[7],
      arm_work: row[8].present? ? JSON.parse(row[8]) : nil,
      temp: row[9]
    )
  end
end
