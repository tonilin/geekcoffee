class LandingMap
  constructor: (@container) ->
    @shop_api_endpoint = Setting.shop_api_endpoint
    @mapSideBar = $(".map-sidebar")
    @shopDetail = $(".shop-detail") 
    @mapContainer = $(".map-container")
    @mapSearchInput = $("#map-search-input")

    @freeWifiSwitch = $("#free-wifi-switch")
    @freePowerOutlets = $("#free-power-outlets")


    @initialMapElemant()
    @initialShopDetailTemplate()
    @queryShops()
    @searchAutoComplete()
    @bindEvents()

  bindEvents: ->

    google.maps.event.addListener @map, 'click', =>
      @stopBounceMarker()
      @infowindow.close()

    google.maps.event.addListener @infowindow, 'closeclick', =>
      @stopBounceMarker()

    @freeWifiSwitch.on "switch-change", =>
      @handleSwitchChange()

    @freePowerOutlets.on "switch-change", =>
      @handleSwitchChange()


  initialMapElemant: ->
    style = [
        {
            "featureType": "water",
            "stylers": [
                {
                    "color": "#46bcec"
                },
                {
                    "visibility": "on"
                }
            ]
        },
        {
            "featureType": "landscape",
            "stylers": [
                {
                    "color": "#f2f2f2"
                }
            ]
        },
        {
            "featureType": "road",
            "stylers": [
                {
                    "saturation": -100
                },
                {
                    "lightness": 45
                }
            ]
        },
        {
            "featureType": "road.highway",
            "stylers": [
                {
                    "visibility": "simplified"
                }
            ]
        },
        {
            "featureType": "road.arterial",
            "elementType": "labels.icon",
            "stylers": [
                {
                    "visibility": "off"
                }
            ]
        },
        {
            "featureType": "administrative",
            "elementType": "labels.text.fill",
            "stylers": [
                {
                    "color": "#444444"
                }
            ]
        },
        {
            "featureType": "transit",
            "stylers": [
                {
                    "visibility": "off"
                }
            ]
        },
        {
            "featureType": "poi",
            "stylers": [
                {
                    "visibility": "off"
                }
            ]
        }
    ]


    mapOptions = {
      zoom: 8
      center: new google.maps.LatLng(23.64, 121.01)
      styles: style
    }

    @map = new google.maps.Map(@container[0], mapOptions);
    @infowindow = new google.maps.InfoWindow

    cluster_options = {
      maxZoom: 18,
      ignoreHidden: true,
      styles: [
        {
          anchorIcon: [32, 32],
          anchorText: [11, -4],
          height: 64,
          url: "/images/cluster.png",
          width: 64,
          textColor: "#FFFFFF",
          fontWeight: "normal",
          fontFamily: 'Playball';
        }
      ]
    }
    @markerClusterer = new MarkerClusterer(@map, [], cluster_options)

  initialShopDetailTemplate: ->
    source   = $("#shop-detail-template").html();
    @shop_detail_template = Handlebars.compile(source);

  queryShops: ->

    $.ajax {
      url: @shop_api_endpoint,
      data: {},
      success: @handleReturnData,
      dataType: "json"
    }

  handleReturnData: (data)=>
    that = this
    shops = data.shops

    for shop in shops
      markerOptions = {
        position: new google.maps.LatLng(shop.lat, shop.lng),
        map: @map,
        title: shop.name,
        icon: "/images/coffee.png",
        id: shop.id,
        is_wifi_free: shop.is_wifi_free,
        power_outlets: shop.power_outlets,
      }

      marker = new google.maps.Marker(markerOptions)

      @markerClusterer.addMarker(marker)

      google.maps.event.addListener marker, 'click', ->
        that.handleMarkerClick(this)

  handleMarkerClick: (marker) ->
    marker_id = marker.get("id")

    @bounceMarker(marker)

    $.ajax {
      url: "#{@shop_api_endpoint}/#{marker_id}",
      data: {},
      dataType: "json"
      success: (data)=>

        @infowindow.setOptions {
          content: @shop_detail_template(data)
        }

        @infowindow.open(@map, marker);
    }

  handleSwitchChange: ->
    filterOption = {}

    if @freeWifiSwitch.bootstrapSwitch("status") == true
      filterOption.is_wifi_free = true

    if @freePowerOutlets.bootstrapSwitch("status") == true
      filterOption.power_outlets = true

    if _.size(filterOption) > 0
      result = _.where(@markers(), filterOption);
      @hiddenAllMarkers()
      for marker in result
        marker.setVisible(true)
    else
      @showAllMarkers()

    @repaint()


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


  searchAutoComplete: (marker) ->
    @mapSearchInput.on "keydown", (event) =>
      if event.keyCode == 13
        event.preventDefault()

    @autocomplete = new google.maps.places.Autocomplete @mapSearchInput[0], {
      types: ['geocode']
    }
    google.maps.event.addListener @autocomplete, 'place_changed', =>
      place = @autocomplete.getPlace()   

      if !place.geometry
        @addressPrediction(place.name)
      else
        @handlePlaceChaged(place)

  handlePlaceChaged: (place) ->
    location = place.geometry.location
    @moveToLocation(location)
    @zoomIn()
    


  moveToLocation: (location)->
    @map.panTo(location)
  
  zoomIn: ->
    that = this

    setTimeout (->
      that.map.setZoom(16)
    ), 500

  # showSideBar: ->
  #   @mapContainer.addClass("active")

  # hideSideBar: ->
  #   @mapContainer.removeClass("active")

  bounceMarker: (marker)->
    @animationMarker.setAnimation(null) if @animationMarker
    
    @animationMarker = marker
    marker.setAnimation(google.maps.Animation.BOUNCE)

  stopBounceMarker: ->
    @animationMarker.setAnimation(null) if @animationMarker

  markers: ->
    @markerClusterer.getMarkers()

  hiddenAllMarkers: ->
    for marker in @markers()
      marker.setVisible(false)
  showAllMarkers: ->
    for marker in @markers()
      marker.setVisible(true)
  repaint: -> 
    @markerClusterer.repaint()

$ ->
  if $(".shop-map").length > 0
    mapPreviewer = new LandingMap($(".shop-map"))