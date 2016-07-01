json.id workout.id
json.body_weight workout.body_weight
json.routine_name workout.routine.name
json.exercises workout.sets.includes(:exercise).order(:created_at).group_by(&:exercise) do |exercise, sets|
  json.id exercise.id
  json.name exercise.name
  json.sets sets.sort_by(&:created_at) do |set|
    json.partial! 'sets/set', set: set
  end
end
