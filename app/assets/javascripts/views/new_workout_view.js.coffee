class Stronglifters.NewWorkoutView extends Backbone.View
  initialize: (options) ->
    @$el.find('div[name]').each (index, fieldset) ->
      view = new Stronglifters.NewSetView
        el: $(fieldset)

class Stronglifters.NewSetView extends Backbone.View
  events:
    'click .skip': 'removeSet'

  removeSet: (event) ->
    event.preventDefault()
    @remove()
