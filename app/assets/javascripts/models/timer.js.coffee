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
    if @view.get('timer') > 600000
      @stop()

  stop: =>
    if @running()
      clearTimeout @intervalId
      @intervalId = null
      @view.set('clock', null)

  running: ->
    @intervalId?
