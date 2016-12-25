json.body_weight @workout.body_weight
json.routine do |routine|
  json.id @workout.routine.id
  json.name @workout.routine.name
end
json.exercises @workout.sets.group_by(&:exercise) do |exercise, sets|
  json.id exercise.id
  json.name exercise.name
end
#json.sets @workout.sets.group_by(&:exercise) do |exercise, set|
  #json.partial! 'sets/set', set: set
#end
