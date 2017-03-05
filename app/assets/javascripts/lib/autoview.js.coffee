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

document.addEventListener "turbolinks:load", ->
  for element in $("[data-autoview-name]")
    Stronglifters.Autoview.install(element)
