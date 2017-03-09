class CloseNotification extends Stronglifters.Behaviour
  @on "turbolinks:load"

  execute: ->
    $('.delete').on 'click', ->
      $('.delete').parent('div:first').hide()
