class MapPreviewer
  constructor: (@container) ->
    mapOptions = {
      zoom: 7,
      center: new google.maps.LatLng(23.84, 121.01)
    }

    @map = new google.maps.Map(@container[0], mapOptions);

    @bindEvents()
    @addressAutoComplate()

  bindEvents: ->
    $("#shop_address").on "keydown", (event) ->
      event.preventDefault() if event.keyCode is 13

  addressAutoComplate: ->
    @autocomplete = new google.maps.places.Autocomplete $("#shop_address")[0], {
      types: ['geocode']
    }
    google.maps.event.addListener @autocomplete, 'place_changed', =>
      @handlePlaceChaged()

  handlePlaceChaged: ->
    place = @autocomplete.getPlace()   
    location = place.geometry.location
    viewPort = place.geometry.viewport
    lat = location.ob
    lng = location.pb

    @fill_lat_input(lat)
    @fill_lng_input(lng)

    @moveToLocation(location)
    @markLocation(location)

  moveToLocation: (location)->
    @map.setCenter(location)
    @map.setZoom(16)

  markLocation: (location) ->
    @marker ||= new google.maps.Marker
    options = {
      position: location,
      map: @map,
      title:"Hello World!"
    }
    @marker.setOptions(options)

  fill_lat_input: (lat)->
    $("#shop_lat").val(lat)
  fill_lng_input: (lng)->
    $("#shop_lng").val(lng)

$ ->
  if $(".map-preview").length > 0
    mapPreviewer = new MapPreviewer($(".map-preview"))
