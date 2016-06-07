json.id training_session.id
json.body_weight training_session.body_weight
json.workout_name training_session.workout.name
json.exercises training_session.workout.exercise_workouts do |exercise|
  json.id exercise.exercise.id
  json.name exercise.name
  json.sets exercise.sets
  json.repetitions exercise.repetitions
  json.reps training_session.progress_for(exercise.exercise).try(:sets) || exercise.sets.times.map { |x| 0 } do |completed_reps|
    json.target exercise.repetitions
    json.completed completed_reps.to_i
  end
  json.target_weight current_user.next_weight_for(exercise.exercise)
end
