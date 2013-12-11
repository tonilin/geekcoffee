class MapPreviewer
  constructor: (@container) ->
    @initialMapElemant()
    @initialInfoWindowTemplate()

    @shopAddressInput = $("#address-search-input")


    @bindEvents()
    @addressAutoComplate()

  initialMapElemant: ->
    mapOptions = {
      zoom: 7,
      center: new google.maps.LatLng(23.84, 121.01)
    }

    @map = new google.maps.Map(@container[0], mapOptions);
    @infowindow = new google.maps.InfoWindow
    @marker = new google.maps.Marker

  initialInfoWindowTemplate: ->
    source   = $("#info-window-template").html();
    @info_window_template = Handlebars.compile(source);

  bindEvents: ->
    return 


  addressAutoComplate: ->
    @shopAddressInput.on "keydown", (event) =>
      if event.keyCode == 13
        event.preventDefault()

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
        @handlePlaceChaged(result)

  handlePlaceChaged: (place)->
    location = place.geometry.location
    viewPort = place.geometry.viewport
    lat = location.lat()
    lng = location.lng()
    address = place.formatted_address

    @fill_address_input(address)
    @fill_lat_input(lat)
    @fill_lng_input(lng)

    @moveToLocation(location)
    @markLocation(address, location)
    @createInfoWindow(place)

  createInfoWindow: (place) ->
    context = {
      address: place.formatted_address
    }

    @infowindow.setOptions {
      content: @info_window_template(context)
    }

    @infowindow.open(@map, @marker);


  moveToLocation: (location)->
    @map.setCenter(location)
    @map.setZoom(16)

  markLocation: (address, location) ->
    options = {
      position: location,
      map: @map,
      title: address,
      icon: "/images/coffee.png",
    }
    @marker.setOptions(options)

  fill_address_input: (address)->
    $("#shop_address").val(address)
  fill_lat_input: (lat)->
    $("#shop_lat").val(lat)
  fill_lng_input: (lng)->
    $("#shop_lng").val(lng)

$ ->
  if $(".map-preview").length > 0
    mapPreviewer = new MapPreviewer($(".map-preview"))
