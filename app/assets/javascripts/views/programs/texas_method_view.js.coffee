class TexasMethodView extends Stronglifters.Autoview
  @viewName "texas-method-view"
  template: JST['views/programs/texas_method']

  render: () ->
    html = @template(message: 'hello')
    @$el.html(html)
