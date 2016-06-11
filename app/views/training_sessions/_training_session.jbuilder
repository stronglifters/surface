json.id training_session.id
json.body_weight training_session.body_weight
json.workout_name training_session.workout.name
json.exercises training_session.exercise_sessions do |exercise|
  json.id exercise.exercise.id
  json.name exercise.name
  json.reps exercise.sets do |set|
    json.weight set.target_weight
    json.target set.target_repetitions
    json.completed set.actual_repetitions
  end
  json.target_weight current_user.next_weight_for(exercise.exercise)
end
