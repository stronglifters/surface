class Stronglifters.Set extends Backbone.Model
  urlRoot: '/sets'
  started: ->
    completed = @get("actual_repetitions")
    completed != null && completed != 0

  complete: ->
    @set("actual_repetitions", @get("target_repetitions"))

  decrement: ->
    @set("actual_repetitions", @get("actual_repetitions") - 1)

  successful: ->
    @get("target_repetitions") == @get("actual_repetitions")

  workSet: ->
    @get("type") == "WorkSet"

  timed: ->
    @get("target_duration")?
