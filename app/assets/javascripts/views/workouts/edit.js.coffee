Vue.component "exercise-set",
  props: ['set']
  data: ->
    model: new Stronglifters.Set(@set)
  methods:
    updateProgress: (set) ->
      if !@model.started()
        @model.complete()
      else
        @model.decrement()
      @model.save()
      set.actual_repetitions = @model.get('actual_repetitions')
  computed:
    isCompleted: () ->
      @set.actual_repetitions == @set.target_repetitions
    classObject: () ->
      "is-success": @set.actual_repetitions == @set.target_repetitions,
      'is-danger': @set.actual_repetitions && (@set.actual_repetitions != @set.target_repetitions),
