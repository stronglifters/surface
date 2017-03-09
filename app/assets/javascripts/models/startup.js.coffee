class Stronglifters.Startup
  start: ->
    Ractive.DEBUG = false
    new Clipboard('.clipboard-button')
