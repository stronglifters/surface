class Stronglifters.WorkoutView extends Ractive
  template: RactiveTemplates["templates/workout_view"]

  oninit: ->
    @on 'updateProgress', (event) -> @updateProgress(event)
    @observe 'workout.exercises.*.sets.*', (newValue, oldValue, keypath) ->
      @refreshStatus(newValue, oldValue, keypath)

  updateProgress: (event) ->
    completed = @get("#{event.keypath}.actual_repetitions")
    if completed == null || completed == 0
      @set("#{event.keypath}.actual_repetitions", @get("#{event.keypath}.target_repetitions"))
    else
      @subtract("#{event.keypath}.actual_repetitions")
    @saveSet(@get(event.keypath))

  saveSet: (set) ->
    @patch "/exercise_sets/#{set.id}",
      exercise_set:
        actual_repetitions: set.actual_repetitions

  patch: (url, payload) ->
    $.ajax
      url: url,
      dataType: 'json',
      type: 'patch',
      contentType: 'application/json',
      data: JSON.stringify(payload),
      success: (data, statux, xhr) =>
        console.log(data)
      error: (xhr, status, error) ->
        console.log(error)

  refreshStatus: (newValue, oldValue, keypath) ->
    if @get("#{keypath}.actual_repetitions") == null
      @set("#{keypath}.status", "secondary")
      return

    if @get("#{keypath}.target_repetitions") == @get("#{keypath}.actual_repetitions")
      @set("#{keypath}.status", "success")
    else
      @set("#{keypath}.status", "alert")
