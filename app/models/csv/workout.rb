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

  def workout
    find(OpenStruct.new(name: 'Deadlift')) ? 'B' : 'A'
  end

  def find(exercise)
    exercises.detect do |x|
      x.matches?(exercise)
    end
  end

  def self.map_from(row, user)
    date = user.time_zone.local_to_utc(Date.strptime(row[0], "%m/%d/%y").to_time)

    workout = new(date: date, note: row[1], body_weight_kg: row[2], body_weight_lb: row[3])
    # skip additional exercises for now
    row[4..-1].take(3 * 8).each_slice(8) do |slice|
      workout.exercises << Csv::Exercise.new(
        name: slice[0],
        weight_kg: slice[1],
        weight_lb: slice[2],
        sets: slice[3..(slice.size)],
      )
    end

    # import additional exercises
    row[(4 + (3 * 8))..-1].each_slice(6) do |slice|
      next if slice[0].nil?
      exercise = Csv::Exercise.new(
        name: slice[0],
        weight_kg: slice[1],
        weight_lb: slice[2],
        sets: slice[3..(slice.size)],
      )
      workout.exercises << exercise
    end
    workout
  end
end
