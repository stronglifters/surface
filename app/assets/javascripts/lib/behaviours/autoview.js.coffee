class Autoview extends Stronglifters.Behaviour
  @on "turbolinks:load"

  execute: ->
    for element in $("[data-autoview-name]")
      Stronglifters.Autoview.install(element)
