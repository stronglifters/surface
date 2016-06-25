json.id workout.id
json.body_weight workout.body_weight
json.routine_name workout.routine.name
json.exercises workout.sets.order(:created_at).group_by(&:exercise) do |exercise, sets|
  json.id exercise.id
  json.name exercise.name
  json.sets sets.sort_by(&:created_at) do |set|
    json.id set.id
    json.target_weight set.target_weight
    json.target_repetitions set.target_repetitions
    json.actual_repetitions set.actual_repetitions
  end
end
