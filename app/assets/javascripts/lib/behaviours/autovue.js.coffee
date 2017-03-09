class Stronglifters.Autovue extends Stronglifters.Behaviour
  @on "turbolinks:load"

  execute: ->
    for element in $("[data-autovue]")
      window.views ?= []
      window.views.push new Vue
        el: element
        data: gon
