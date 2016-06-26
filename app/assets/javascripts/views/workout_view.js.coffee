#= require models/timer
#= require models/set
class Stronglifters.WorkoutView extends Ractive
  template: RactiveTemplates["templates/workout_view"]

  oninit: ->
    @on 'updateProgress', (event) ->
      model = new Stronglifters.Set(@get(event.keypath))
      @updateProgress(model)
      x = {}
      _.each _.keys(model.changed), (key) ->
        x["#{event.keypath}.#{key}"] = model.changed[key]
      @set(x)

    @observe 'workout.exercises.*.sets.*', (newValue, oldValue, keypath) ->
      @refreshStatus(newValue, oldValue, keypath)
    @set('message', "Let's do this!")
    @clock = new Stronglifters.Timer(@)

  updateProgress: (model) ->
    if !model.started()
      model.complete()
    else
      model.decrement()
    model.save()

    if model.successful()
      @set('message', "If it was easy break for 1:30, otherwise rest for 3:00.")
      @set('alertStatus', 'radius')
    else
      @set('alertStatus', 'alert')
      @set('message', "Take a 5:00 break.")
    @clock.start()

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
