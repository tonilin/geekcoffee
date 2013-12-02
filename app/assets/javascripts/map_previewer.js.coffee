class MapPreviewer
  constructor: (@container) ->
    mapOptions = {
      zoom: 7,
      center: new google.maps.LatLng(23.84, 121.01)
    }

    @map = new google.maps.Map(@container[0], mapOptions);
    @shopAddressInput = $("#shop_address")
    @submitBtn = $(".btn-submit")


    @bindEvents()
    @addressAutoComplate()

  bindEvents: ->
    return 


  addressAutoComplate: ->
    @shopAddressInput.on "keydown", (event) =>
      if event.keyCode == 13
        event.preventDefault()
      else
        @submitBtn.attr("disabled", "disabled")

    @autocomplete = new google.maps.places.Autocomplete @shopAddressInput[0], {
      types: ['geocode']
    }
    google.maps.event.addListener @autocomplete, 'place_changed', =>
      place = @autocomplete.getPlace()   

      if !place.geometry
        @addressPrediction(place.name)
      else
        @handlePlaceChaged(place)

  addressPrediction: (address_name)=>

    prediction = new google.maps.places.AutocompleteService()

    prediction.getPlacePredictions {
      input: address_name,
      types: ['geocode']
    }, (place)=>
      if !place
        return

      place = place[0]
      placeReference = place.reference

      placeDetailService = new google.maps.places.PlacesService(@map)
      placeDetailService.getDetails {
        reference: placeReference
      }, (result) =>
        @shopAddressInput.val(result.formatted_address)
        @handlePlaceChaged(result)

  handlePlaceChaged: (place)->
    location = place.geometry.location
    viewPort = place.geometry.viewport
    lat = location.ob
    lng = location.pb

    @fill_lat_input(lat)
    @fill_lng_input(lng)

    @moveToLocation(location)
    @markLocation(location)

    @shopAddressInput.attr("disabled", "disabled")
    @submitBtn.removeAttr("disabled")

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
