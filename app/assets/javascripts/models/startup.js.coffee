class Stronglifters.Startup
  start: ->
    Ractive.DEBUG = false
    new Clipboard('.clipboard-button')
    $(document).on 'page:fetch', ->
      $(".loading-indicator").show()
    $(document).on 'page:change', ->
      $(".loading-indicator").hide()
    $(document).foundation()
