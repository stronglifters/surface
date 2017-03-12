###
Example usage:

class MyView extends Stronglifters.Autoview
  @viewName "my-view"
  template: JST['views/my_view']

  render: () ->
    @$el.html(@template(message: 'hello'))

<div data-autoview-name="my-view"></div>
<div data-autoview-name="my-view" data-model="user" data-model-attributes="<%= user.to_json %>">
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
      model: @createModel($element.data('model'), $element.data('model-attributes'))
    view.render()
    @views[name] ?= []
    @views[name].push(view)

  @createModel: (name, attributes) ->
    Stronglifters.AutoModel.createModel(name, attributes)

  render: -> { }
