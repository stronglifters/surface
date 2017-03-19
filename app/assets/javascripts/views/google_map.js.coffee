class Stronglifters.GoogleMap
  constructor: (div) ->
    @div = document.getElementById(div)

  present: (options) ->
    coordinates = new google.maps.LatLng(options.latitude, options.longitude)
    map = new google.maps.Map(@div, {
      center: coordinates,
      zoom: 15,
      scrollwheel: false,
      mapTypeId: google.maps.MapTypeId.TERRAIN,
    })
    marker = new google.maps.Marker({
      map: map,
      position: coordinates,
      title: options.name
    })
