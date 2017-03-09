class HamburgerMenu extends Stronglifters.Behaviour
  @on "turbolinks:load"

  execute: ->
    $(".nav-toggle").on "click", ->
      $(".nav-menu").toggleClass "is-active"

class CloseNotification extends Stronglifters.Behaviour
  @on "turbolinks:load"

  execute: ->
    $('.delete').on 'click', ->
      $('.delete').parent('div:first').hide()


class CloseModal extends Stronglifters.Behaviour
  @on "turbolinks:load"

  execute: ->
    $('.close-modal').on 'click', ->
      $('.modal').removeClass('is-active')
