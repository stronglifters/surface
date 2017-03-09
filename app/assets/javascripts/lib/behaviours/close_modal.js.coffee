class CloseModal extends Stronglifters.Behaviour
  @on "turbolinks:load"

  execute: ->
    $('.close-modal').on 'click', ->
      $('.modal').removeClass('is-active')
