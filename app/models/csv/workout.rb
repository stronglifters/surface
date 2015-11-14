class Csv::Workout
  attr_accessor :date, :note, :workout
  attr_accessor :body_weight_kg, :body_weight_lb
  attr_accessor :exercises

  def self.map_from(row, user)
    workout = new
    day, month, year = row[0].split('/')
    year = "20#{year}"
    workout.date = user.timezone.local_to_utc(Time.utc(year, month, day))
    workout.note = row[1]
    workout.workout = row[2]
    workout.body_weight_kg = row[3]
    workout.body_weight_lb = row[4]
    workout.exercises = []
    all_exercises = row[5..(row.size)]
    # skip additional exercises for now
    all_exercises.take(3 * 8).each_slice(8) do |slice|
      exercise = Csv::Exercise.new
      exercise.name = slice[0]
      exercise.weight_kg = slice[1]
      exercise.weight_lb = slice[2]
      exercise.sets = slice[3..(slice.size)]
      workout.exercises << exercise
    end
    workout
  end
end
