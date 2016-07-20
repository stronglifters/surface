class Stronglifters.Timer
  constructor: (databag, key = 'clock', maxMilliseconds = 600000) ->
    @databag = databag
    @format = 'mm:ss'
    @interval = 1000
    @key = key
    @maxMilliseconds = maxMilliseconds

  start: ->
    @stop()

    @databag.set('timer', 0)
    @intervalId = setInterval @refreshTimer, @interval

  refreshTimer: =>
    @databag.add('timer', @interval)
    @databag.set(@key, moment.utc(@databag.get('timer')).format(@format))
    if @databag.get('timer') >= @maxMilliseconds
      @stop()

  stop: =>
    if @running()
      clearTimeout @intervalId
      @intervalId = null

  running: ->
    @intervalId?
