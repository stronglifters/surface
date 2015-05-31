class AndroidImport
  attr_reader :user, :program

  def initialize(user, program)
    @user = user
    @program = program
  end

  def import(row)
    user.training_sessions.create_workout_from(map_from(row), program)
  end

  private

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
