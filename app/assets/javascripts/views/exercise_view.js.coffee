#= require templates/exercise_view
class Stronglifters.ExerciseView extends Ractive
  template: RactiveTemplates["templates/exercise_view"]
  data:
    name: ''
    sets: 5
    repeitions: 5
    target_weight: 100
    reps: [ ]

