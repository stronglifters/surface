class Android::Workout
  attr_accessor :id, :date, :workout
  attr_accessor :exercise_1, :exercise_2, :exercise_3
  attr_accessor :note, :body_weight, :arm_work, :temp

  def initialize(attributes = {})
    attributes.each do |attribute|
      send("#{attribute.first}=", attribute.last)
    end
  end

  def exercises
    @exercises ||= [
      exercise_1,
      exercise_2,
      exercise_3,
    ]
  end
end
