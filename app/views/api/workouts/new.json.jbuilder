json.body_weight @workout.body_weight
json.exercises @workout.sets.group_by(&:exercise) do |exercise, sets|
  json.id exercise.id
  json.name exercise.name
end
