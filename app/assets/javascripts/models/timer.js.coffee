class Stronglifters.Timer
  @ONE_SECOND=1000
  constructor: (view) ->
    @view = view

  start: ->
    @stop()

    @view.set('timer', 0)
    @intervalId = setInterval @refreshTimer, @ONE_SECOND

  refreshTimer: =>
    @view.add('timer', @ONE_SECOND)
    @view.set('clock', moment.utc(@view.get('timer')).format('mm:ss'))

  stop: =>
    if @running()
      clearTimeout @intervalId
      @intervalId = null

  running: ->
    @intervalId?
