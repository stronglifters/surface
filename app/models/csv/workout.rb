class Csv::Workout
  attr_accessor :date, :note, :workout
  attr_accessor :body_weight_kg, :body_weight_lb
  attr_accessor :exercises

  def initialize(attributes = {})
    attributes.each do |attribute|
      send("#{attribute.first}=", attribute.last)
    end
    @exercises = []
  end

  def find(exercise)
    exercises.detect do |x|
      x.matches?(exercise)
    end
  end

  def self.map_from(row, user)
    day, month, year = row[0].split("/")
    year = "20#{year}"
    workout = new(
      date: user.timezone.local_to_utc(Time.utc(year, month, day)),
      note: row[1],
      workout: row[2],
      body_weight_kg: row[3],
      body_weight_lb: row[4],
    )
    # skip additional exercises for now
    row[5..(row.size)].take(3 * 8).each_slice(8) do |slice|
      workout.exercises << Csv::Exercise.new(
        name: slice[0],
        weight_kg: slice[1],
        weight_lb: slice[2],
        sets: slice[3..(slice.size)],
      )
    end
    workout
  end
end
