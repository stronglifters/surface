Stronglifters.HomeGym = Ractive.extend
  template: RactiveTemplates["templates/home_gym"]
  data:
    city: 'Calgary'
    gyms: []
    search:
      button:
        disabled: true
    searching: false

  oninit: ->
    @on 'search', (event) -> @search(event)
    @on 'choose', (event) -> @choose(event.context)
    @observe 'gym', -> @nameChanged()

  search: (event) ->
    event.original.preventDefault()
    @disableSearchButton()
    @clearResults()
    @set(searching: true)
    $.getJSON @buildSearchUrl(), (data) =>
      @set(searching: false)
      @displayResults(data)
      @enableSearchButton()

  choose: (gym) ->
    $.ajax
      url: '/gyms',
      dataType: 'json',
      type: 'post',
      contentType: 'application/json',
      data: JSON.stringify({ yelp_id: gym.yelp_id }),
      success: (gym, statux, xhr) =>
        $('#home-gym-name').html(gym.name)
        $('#profile_gym_id').val(gym.id)
        @closeModal()
      error: (xhr, status, error) ->
        console.log(error)

  displayResults: (data) ->
    @set(gyms: data.gyms)

  buildSearchUrl: ->
    params = [
      "q=#{@get('gym')}",
      "categories[]=gyms",
      "categories[]=stadiumsarenas",
      "city=#{@get('city')}",
      "source=yelp",
    ]
    "/gyms?#{params.join("&")}"

  closeModal: ->
    $('#homeGymModal').foundation('reveal', 'close')

  enableSearchButton: ->
    @set('search.button.disabled': false)

  disableSearchButton: ->
    @set('search.button.disabled': true)

  nameChanged: ->
    if @valid()
      @enableSearchButton()
    else
      @disableSearchButton()

  valid: ->
    @get('gym').trim().length >= 2

  clearResults: ->
    @set(gyms: [])
