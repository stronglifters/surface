class Stronglifters.Startup
  start: ->
    Ractive.DEBUG = false
    $(document).on 'page:fetch', ->
      $(".loading-indicator").show()
    $(document).on 'page:change', ->
      $(".loading-indicator").hide()
    $(document).foundation()
