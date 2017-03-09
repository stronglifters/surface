class HamburgerMenu extends Stronglifters.Behaviour
  @on "turbolinks:load"

  execute: ->
    $(".nav-toggle").on "click", ->
      $(".nav-menu").toggleClass "is-active"
