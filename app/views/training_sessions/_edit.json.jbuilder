json.id training_session.id
json.body_weight training_session.body_weight
json.workout do
  json.name training_session.workout.name
end
json.exercises training_session.workout.exercise_workouts do |exercise|
  json.name exercise.name
  json.sets exercise.sets
  json.completed_sets training_session.progress_for(exercise).try(:sets) || exercise.sets.times.map { |x| 0 }
  json.repetitions exercise.repetitions
  json.target_weight current_user.next_weight_for(exercise.exercise)
end
json.count training_session.exercise_sessions.count

