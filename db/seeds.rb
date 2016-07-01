# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
program = Program.find_or_create_by!(name: Program::STRONG_LIFTS)
squat = Exercise.find_or_create_by!(name: "Squat")
bench_press = Exercise.find_or_create_by!(name: "Bench Press")
barbell_row = Exercise.find_or_create_by!(name: "Barbell Row")
overhead_press = Exercise.find_or_create_by!(name: "Overhead Press")
deadlift = Exercise.find_or_create_by!(name: "Deadlift")
dips = Exercise.find_or_create_by!(name: "Dips")
chin_ups = Exercise.find_or_create_by!(name: "Chinups")

workout_a = program.routines.find_or_create_by(name: "A")
workout_a.add_exercise(squat, sets: 5, repetitions: 5)
workout_a.add_exercise(bench_press, sets: 5, repetitions: 5)
workout_a.add_exercise(barbell_row, sets: 5, repetitions: 5)
workout_a.add_exercise(dips, sets: 3, repetitions: 5)

workout_b = program.routines.find_or_create_by(name: "B")
workout_b.add_exercise(squat, sets: 5, repetitions: 5)
workout_b.add_exercise(overhead_press, sets: 5, repetitions: 5)
workout_b.add_exercise(deadlift, sets: 1, repetitions: 5)
workout_b.add_exercise(chin_ups, sets: 3, repetitions: 5)
