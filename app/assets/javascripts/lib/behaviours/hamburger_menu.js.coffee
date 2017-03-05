$(document).on "turbolinks:load", () ->
  $(".nav-toggle").on "click", (event) ->
    $(".nav-menu").toggleClass "is-active"
