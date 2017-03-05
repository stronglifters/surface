###
Example usage:

class MyView extends Stronglifters.Autoview
  @viewName "my-view"
  template: JST['views/my_view']

  render: () ->
    @$el.html(@template(message: 'hello'))

<div data-autoview-name="my-view"></div>
###
class Stronglifters.Autoview extends Backbone.View
  @views: {}
  @constructors: {}

  @viewName: (name) ->
    @constructors[name] = this
    @::name = name

  @install: (element) ->
    $element = $(element)
    name = $element.data("autoview-name")
    view = new @constructors[name]
      el: element
      $el: $element
    view.render()
