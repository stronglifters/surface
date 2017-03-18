class CloseModal extends Stronglifters.Behaviour
  @on "turbolinks:load"

  execute: ->
    $('.close-modal').on 'click', ->
      $('.modal').removeClass('is-active')

class OpenModal extends Stronglifters.Behaviour
  @on "turbolinks:load"

  execute: ->
    $('button[data-modal]').on 'click', (event) ->
      modalSelector = $(event.target).data('modal')
      $(modalSelector).addClass('is-active')
