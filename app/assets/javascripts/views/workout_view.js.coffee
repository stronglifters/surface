class Stronglifters.WorkoutView extends Ractive
  template: RactiveTemplates["templates/workout_view"]

  oninit: ->
    @on 'updateProgress', (event) -> @updateProgress(event)
    @observe 'workout.exercises.*.sets.*', (newValue, oldValue, keypath) ->
      @refreshStatus(newValue, oldValue, keypath)
    @set('message', "Let's do this!")

  updateProgress: (event) ->
    @stopTimer()
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
    @startTimer()

  startTimer: ->
    @set('timer', 0)
    @intervalId = setInterval @refreshTimer, 1000

  refreshTimer: =>
    @add('timer', 1000)
    @set('clock', moment.utc(@get('timer')).format('mm:ss'))

  stopTimer: =>
    clearTimeout @intervalId

  saveSet: (set) ->
    @patch "/sets/#{set.id}",
      set:
        actual_repetitions: set.actual_repetitions

  patch: (url, payload) ->
    $.ajax
      url: url,
      dataType: 'json',
      type: 'patch',
      contentType: 'application/json',
      data: JSON.stringify(payload),
      success: (data, statux, xhr) ->
        console.log("Saved: #{data}")
      error: (xhr, status, error) ->
        console.log(error)

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
