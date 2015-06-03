# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
program =  Program.create!(name: Program::STRONG_LIFTS)
squat =  Exercise.create!(name: "Squat")
bench_press = Exercise.create!(name: "Bench Press")
barbell_row = Exercise.create!(name: "Barbell Row")
overhead_press = Exercise.create!(name: "Overhead Press")
deadlift = Exercise.create!(name: "Deadlift")

workout_a = program.workouts.create(name: "A")
workout_a.add_exercise(squat, sets: 5, repetitions: 5)
workout_a.add_exercise(bench_press, sets: 5, repetitions: 5)
workout_a.add_exercise(barbell_row, sets: 5, repetitions: 5)

workout_b = program.workouts.create(name: "B")
workout_b.add_exercise(squat, sets: 5, repetitions: 5)
workout_b.add_exercise(overhead_press, sets: 5, repetitions: 5)
workout_b.add_exercise(deadlift, sets: 1, repetitions: 5)
