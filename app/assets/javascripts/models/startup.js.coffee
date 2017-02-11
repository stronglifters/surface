class Stronglifters.Startup
  start: ->
    Ractive.DEBUG = false
    new Clipboard('.clipboard-button')
    $(document).on 'turbolinks:request-start', ->
      $(".loading-indicator").show()
    $(document).on 'turbolinks:request-end', ->
      $(".loading-indicator").hide()
