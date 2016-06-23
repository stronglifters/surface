class Stronglifters.TrainingSessionView extends Ractive
  template: RactiveTemplates["templates/training_session_view"]

  oninit: ->
    @on 'updateProgress', (event) -> @updateProgress(event)
    @on 'completeExercise', (event) -> @completeExercise(event.context)
    @observe 'training_session.exercises.*.sets.*', (newValue, oldValue, keypath) ->
      @refreshStatus(newValue, oldValue, keypath)

  updateProgress: (event) ->
    completed = @get("#{event.keypath}.completed")
    if completed == null || completed == 0
      @set("#{event.keypath}.completed", @get("#{event.keypath}.target"))
    else
      @subtract("#{event.keypath}.completed")

  refreshStatus: (newValue, oldValue, keyPath) ->
    if @get("#{keyPath}.completed") == 0
      @set("#{keyPath}.status", "secondary")
      return

    if @get("#{keyPath}.target") == @get("#{keyPath}.completed")
      @set("#{keyPath}.status", "success")
    else
      @set("#{keyPath}.status", "alert")

  completeExercise: (exercise) ->
    payload =
      training_session:
        exercise_id: exercise.id
        sets: _.map exercise.sets, (set) ->
          completed: set.completed
          weight: exercise.target_weight
    console.log(payload)

    $.ajax
      url: "/training_sessions/#{@get('training_session.id')}",
      dataType: 'json',
      type: 'patch',
      contentType: 'application/json',
      data: JSON.stringify(payload),
      success: (gym, statux, xhr) =>
        exercise.completed = true
        @updateModel()
      error: (xhr, status, error) ->
        console.log(error)
