json.body_weight @workout.body_weight
json.routine do |routine|
  json.id @workout.routine.id
  json.name @workout.routine.name
end
json.exercises @workout.sets.group_by(&:exercise) do |exercise, sets|
  json.id exercise.id
  json.name exercise.name
end
json.sets @workout.sets do |set|
  json.partial! 'api/sets/set', set: set
end
