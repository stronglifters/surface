class Stronglifters.Timer
  constructor: (options) ->
    @databag = options['databag']
    @format = options['format'] || 'mm:ss'
    @interval = 1000
    @key = options['key'] || 'clock'
    @maxMilliseconds = options['maxMilliseconds'] || 600000
    @success = options['success'] || -> { }

  start: (options) ->
    @stop()

    @databag.set('timer', 0)
    @intervalId = setInterval @refreshTimer, @interval

  refreshTimer: =>
    @databag.add('timer', @interval)
    @databag.set(@key, moment.utc(@databag.get('timer')).format(@format))
    if @databag.get('timer') >= @maxMilliseconds
      @stop()
      @success()

  stop: =>
    if @running()
      clearTimeout @intervalId
      @intervalId = null

  running: ->
    @intervalId?
