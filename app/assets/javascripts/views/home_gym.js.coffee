Stronglifters.HomeGym = Ractive.extend
  template: RactiveTemplates["templates/home_gym"]
  oninit: ->
    @set(city: 'Calgary')
    @set(gyms: [])
    @on 'search', (event) -> @search()
    @on 'choose', (event) -> @choose(event.context)

  search: ->
    $.getJSON @buildUrl(), (data) =>
      @displayResults(data)

  choose: (gym) ->
    $('#home_gym_name').html(gym.name)
    $('#home_gym_yelp_id').val(gym.yelp_id)
    @closeModal()

  displayResults: (data) ->
    @set(gyms: data)

  buildUrl: ->
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
