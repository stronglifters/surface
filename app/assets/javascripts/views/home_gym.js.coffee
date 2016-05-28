Stronglifters.HomeGym = Ractive.extend
  template: RactiveTemplates["templates/home_gym"]
  oninit: ->
    @set(city: 'Calgary')
    @set(gyms: [])
    @on 'search', (event) -> @search()
    @on 'choose', (event) -> @choose(event.context)

  search: ->
    $.getJSON @buildSearchUrl(), (data) =>
      @displayResults(data)

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
