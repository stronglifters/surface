#= require views/training_session_view
describe "TrainingSessionView", ->
  beforeEach ->
    @el = $('<div>')
    @subject = new Stronglifters.TrainingSessionView(
      el: @el,
      data: ->
        {
          id: "1",
          body_weight: 225,
          workout_name: "A",
          exercises: [{
              name: 'Squat',
              sets: 3,
              repetitions: 5,
              reps: [{target: 5, completed: 0}, {target: 5, completed: 1},{target: 5, completed: 2}]
              target_weight: 315,
          }]
        }
    )

  it "has one exercise", ->
    @subject.get('exercises')
    expect(@subject.get('exercises').length).toEqual(1)

  it "indicates no progress recorded", ->
    result = @subject.get('exercises.0.reps.0.status')
    expect(result).toEqual('secondary')

  it "disables the other sets", ->
    secondSetButton = @el.find('button:eq(1)')
    thirdSetButton = @el.find('button:eq(2)')
    expect(secondSetButton.attr('disabled')).toEqual('disabled')
    expect(thirdSetButton.attr('disabled')).toEqual('disabled')

  describe "updating progress", ->
    describe "when no reps are completed", ->
      it "sets the reps to the target", ->
        @el.find('button').first().trigger('click')
        result = @subject.get('exercises.0.reps.0.completed')
        expect(result).toEqual(5)

      it "indicates a successful set", ->
        @el.find('button').first().trigger('click')
        result = @subject.get('exercises.0.reps.0.status')
        expect(result).toEqual('success')

      it "enables the next set", ->
        @el.find('button').first().trigger('click')
        expect(@el.find('button:eq(1)').attr('disabled')).toEqual('')

    describe "when at least one rep is completed", ->
      beforeEach ->
        @subject.set('exercises.0.reps.0.completed', 5)

      it 'decrements the count', ->
        @el.find('button').first().trigger('click')
        result = @subject.get('exercises.0.reps.0.completed')
        expect(result).toEqual(4)

      it "indicates a failed set", ->
        @el.find('button').first().trigger('click')
        result = @subject.get('exercises.0.reps.0.status')
        expect(result).toEqual('alert')
