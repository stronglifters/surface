class Stronglifters.Timer
  constructor: (view) ->
    @view = view

  start: ->
    @stop()

    @view.set('timer', 0)
    @intervalId = setInterval @refreshTimer, 1000

  refreshTimer: =>
    @view.add('timer', 1000)
    @view.set('clock', moment.utc(@view.get('timer')).format('mm:ss'))

  stop: =>
    if @running()
      clearTimeout @intervalId
      @intervalId = null

  running: ->
    @intervalId?
