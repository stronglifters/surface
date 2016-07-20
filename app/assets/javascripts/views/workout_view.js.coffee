#= require models/timer
#= require models/set
class Stronglifters.WorkoutView extends Ractive
  template: RactiveTemplates["templates/workout_view"]

  oninit: ->
    @clock = new Stronglifters.Timer(@)
    @timers = { }
    @on 'updateProgress', (event) ->
      @withModel event.keypath, (model) =>
        @updateProgress(model)

    @observe 'workout.exercises.*.sets.*', (newValue, oldValue, keypath) ->
      @withModel keypath, (model) =>
        @refreshStatus model, keypath

  withModel: (keypath, callback) ->
    model = new Stronglifters.Set(@get(keypath))
    model.set 'keypath', keypath
    callback(model)
    prefix = (x, key) ->
      x["#{keypath}.#{key}"] = model.changed[key]
      x
    @set(_.reduce(_.keys(model.changed), prefix, {}))

  updateProgress: (model) ->
    @set('clock', null)
    @clock.stop()

    if model.timed()
      @startTimerFor(model)
      return

    if !model.started()
      model.complete()
    else
      model.decrement()
    model.save()

    if model.successful()
      if model.workSet()
        message = "If it was easy break for 1:30, otherwise rest for 3:00."
      else
        message = "No rest for the wicked. Let's do this!"
      @displayMessage message, 'success'
    else
      @displayMessage "Take a 5:00 break.", 'alert'

    @clock.start()

  refreshStatus: (model, keypath) ->
    if model.timed()
      return

    if !model.started()
      @set "#{keypath}.status", "secondary hollow"
      return

    if model.successful()
      @set "#{keypath}.status", "success"
    else
      @set "#{keypath}.status", "alert"

  displayMessage: (message, status) ->
    @set 'message', message
    @set 'alertStatus', status

  startTimerFor: (model) ->
    keypath = model.get('keypath')
    timer = @timers[keypath]
    if timer?
      timer.stop()
    else
      timer = new Stronglifters.Timer(@, "#{keypath}.actual_duration", 60000)
      @timers[keypath] = timer
      timer.start()
