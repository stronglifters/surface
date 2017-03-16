class Stronglifters.Autovue extends Stronglifters.Behaviour
  @on "turbolinks:load"

  execute: ->
    data = gon? ? gon : {}
    for element in $("[data-autovue]")
      window.views ?= []
      window.views.push new Vue
        el: element
        data: data
