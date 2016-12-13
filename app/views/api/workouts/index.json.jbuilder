json.cache! @workouts, expires_in: 1.hour do
  json.workouts @workouts do |workout|
    json.partial! 'workout', workout: workout
  end
end
