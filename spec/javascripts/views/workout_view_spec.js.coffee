#= require views/workout_view
describe "WorkoutView", ->
  beforeEach ->
    @el = $('<div>')
    @subject = new Stronglifters.WorkoutView
      el: @el,
      data: ->
        workout:
          id: "1",
          body_weight: 225,
          routine_name: "A",
          exercises: [{
            id: '65ba3c72-4c4f-4226-bf53-b67d3edc3dda',
            name: 'Squat',
            sets: [
              {
                id: '5af1129b-b1d6-4e87-ab13-278f64d6e8ea',
                target_weight: 315,
                target_repetitions: 5,
                actual_repetitions: null
              },
              {
                id: '8e44a98e-f109-497f-a2ec-66e9b64c532a',
                target_weight: 315,
                target_repetitions: 5,
                actual_repetitions: 1
              },
              {
                id: 'be848972-8549-4f44-a3ce-2295783bf2b1',
                target_weight: 315,
                target_repetitions: 5,
                actual_repetitions: 2
              },
            ]
          }]

  it "has one exercise", ->
    @subject.get('workout.exercises')
    expect(@subject.get('workout.exercises').length).toEqual(1)

  it "indicates no progress recorded", ->
    result = @subject.get('workout.exercises.0.sets.0.status')
    expect(result).toEqual('secondary hollow')

  describe "updating progress", ->
    describe "when no reps are completed", ->
      it "sets the reps to the target", ->
        @el.find('button').first().trigger('click')
        result = @subject.get('workout.exercises.0.sets.0.actual_repetitions')
        expect(result).toEqual(5)

      it "indicates a successful set", ->
        @el.find('button').first().trigger('click')
        result = @subject.get('workout.exercises.0.sets.0.status')
        expect(result).toEqual('is-success')

    describe "when at least one rep is completed", ->
      beforeEach ->
        @subject.set('workout.exercises.0.sets.0.actual_repetitions', 5)

      it 'decrements the count', ->
        @el.find('button').first().trigger('click')
        result = @subject.get('workout.exercises.0.sets.0.actual_repetitions')
        expect(result).toEqual(4)

      it "indicates a failed set", ->
        @el.find('button').first().trigger('click')
        result = @subject.get('workout.exercises.0.sets.0.status')
        expect(result).toEqual('is-danger')
