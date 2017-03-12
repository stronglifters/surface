class ExerciseSetView extends Stronglifters.Autoview
  @viewName "exercise-set-view"
  events:
    'click button': 'updateProgress'

  updateProgress: ->
    if !@model.started()
      @model.complete()
    else
      @model.decrement()
    @model.save()
    @$('button').html(@model.get('actual_repetitions'))

    if @model.successful()
      @$('button').addClass('is-success')
      @$('button').removeClass('is-danger')
      if @model.workSet()
        message = "If it was easy break for 1:30, otherwise rest for 3:00."
      else
        message = "No rest for the wicked. Let's do this!"
      @displayMessage message, 'is-success'
    else
      @$('button').removeClass('is-success')
      @$('button').addClass('is-danger')
      @displayMessage "Take a 5:00 break.", 'is-danger'

  displayMessage: (message) ->
    console.log(message)
