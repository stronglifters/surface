json.id training_session.id
json.body_weight training_session.body_weight
json.workout_name training_session.workout.name
json.exercises training_session.exercise_sets.order(:created_at).group_by(&:exercise) do |exercise, exercise_sets|
  json.id exercise.id
  json.name exercise.name
  json.sets exercise_sets.sort_by(&:created_at) do |set|
    json.id set.id
    json.target_weight set.target_weight
    json.target_repetitions set.target_repetitions
    json.actual_repetitions set.actual_repetitions
  end
end
