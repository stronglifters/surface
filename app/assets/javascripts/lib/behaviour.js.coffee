class Stronglifters.Behaviour
  @events: {}

  @on: (event) ->
    @events[event] ?= []
    @events[event].push(this)

  @install: () ->
    for event of @events
      for behaviour in @events[event]
        new behaviour().execute()
