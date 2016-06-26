#= require models/timer
#= require models/set
class Stronglifters.WorkoutView extends Ractive
  template: RactiveTemplates["templates/workout_view"]

  oninit: ->
    @on 'updateProgress', (event) -> @updateProgress(event)
    @observe 'workout.exercises.*.sets.*', (newValue, oldValue, keypath) ->
      @refreshStatus(newValue, oldValue, keypath)
    @set('message', "Let's do this!")
    @clock = new Stronglifters.Timer(@)

  updateProgress: (event) ->
    completed = @get("#{event.keypath}.actual_repetitions")
    if completed == null || completed == 0
      @set("#{event.keypath}.actual_repetitions", @get("#{event.keypath}.target_repetitions"))
    else
      @subtract("#{event.keypath}.actual_repetitions")
    @saveSet(@get(event.keypath))

    if @successful(event.keypath)
      @set('message', "If it was easy break for 1:30, otherwise rest for 3:00.")
      @set('alertStatus', 'radius')
    else
      @set('alertStatus', 'alert')
      @set('message', "Take a 5:00 break.")
    @clock.start()

  saveSet: (set) ->
    model = new Stronglifters.Set(set)
    model.save

  successful: (keypath) ->
    @get("#{keypath}.target_repetitions") == @get("#{keypath}.actual_repetitions")

  refreshStatus: (newValue, oldValue, keypath) ->
    if @get("#{keypath}.actual_repetitions") == null
      @set("#{keypath}.status", "secondary")
      return

    if @successful(keypath)
      @set("#{keypath}.status", "success")
    else
      @set("#{keypath}.status", "alert")
