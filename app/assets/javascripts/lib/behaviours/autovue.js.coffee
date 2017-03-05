class Autovue extends Stronglifters.Behaviour
  @on "turbolinks:load"

  execute: ->
    for element in $("[data-autovue]")
      window.vue = new Vue
        el: element
        data: gon
