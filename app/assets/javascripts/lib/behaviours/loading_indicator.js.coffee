class DisplayLoadingIndicator extends Stronglifters.Behaviour
  @on "turbolinks:load"

  execute: ->
    $(document).on 'turbolinks:request-start', ->
      $(".loading-indicator").show()


class HideLoadingIndicator extends Stronglifters.Behaviour
  @on "turbolinks:load"

  execute: ->
    $(document).on 'turbolinks:request-end', ->
      $(".loading-indicator").hide()
