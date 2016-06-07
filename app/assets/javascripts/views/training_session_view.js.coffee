class Stronglifters.TrainingSessionView extends Ractive
  template: RactiveTemplates["templates/training_session_view"]

  oninit: ->
    @on 'updateProgress', (event) -> @updateProgress(event)
    @observe 'exercises.*.reps.*', (newValue, oldValue, keypath) ->
      @refreshStatus(newValue, oldValue, keypath)

  updateProgress: (event) ->
    if @get("#{event.keypath}.completed") == 0
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
