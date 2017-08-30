Vue.component "personal-records",
  props: ['personal_records']

Vue.component "volume-day",
  props: ['personal_records']
  methods:
    rounded: (n) ->
      n - (n % 5)
  computed:
    squat: ->
      @rounded(@personal_records.squat * 0.9)
    bench_press: ->
      @rounded(@personal_records.bench_press * 0.9)
    overhead_press: ->
      @rounded(@personal_records.overhead_press * 0.9)
    barbell_row: ->
      @rounded(@personal_records.barbell_row * 0.9)

Vue.component "recovery-day",
  props: ['personal_records']
  methods:
    rounded: (n) ->
      n - (n % 5)
  computed:
    squat: ->
      @rounded(@rounded(@personal_records.squat * 0.9) * 0.8)
    bench_press: ->
      @rounded(@personal_records.bench_press * 0.9)
    overhead_press: ->
      @rounded(@personal_records.overhead_press * 0.9)

Vue.component "intensity-day",
  props: ['personal_records']
  computed:
    squat: ->
      @personal_records.squat + 5
    bench_press: ->
      @personal_records.bench_press + 5
    overhead_press: ->
      @personal_records.overhead_press + 5
    deadlift: ->
      @personal_records.deadlift + 5
