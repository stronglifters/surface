class Stronglifters.Behaviour
  @events: {}

  @on: (event) ->
    @events[event] ?= []
    @events[event].push(this)

  @install: ->
    for event of @events
      @installBehavioursFor(event)
      document.addEventListener event, () =>
        @installBehavioursFor(event)

  @installBehavioursFor: (event) ->
    for behaviour in @events[event]
      new behaviour().execute()
