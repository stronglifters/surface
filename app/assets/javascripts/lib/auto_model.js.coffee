class Stronglifters.AutoModel extends Backbone.Model
  @factories: {}
  @modelName: (name) ->
    @factories[name] = this

  @createModel: (name, attributes) ->
    if (factory = @factories[name])
      new factory(attributes || {})
    else
      new Backbone.Model(attributes || {})
