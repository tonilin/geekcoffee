class LandingMap
  constructor: (@container) ->
    @shop_api_endpoint = Setting.shop_api_endpoint
    @mapSideBar = $(".map-sidebar")
    @shopList = @mapSideBar.find(".shop-list")
    @shopDetail = $(".shop-detail")
    @mapContainer = $(".map-container")
    @mapSearchInput = $("#map-search-input")
    @geolocationBtn = $(".geolocation-btn")

    @freeWifiSwitch = $("#free-wifi-switch")
    @freePowerOutlets = $("#free-power-outlets")


    @initialMapElemant()
    @initialTemplates()
    @queryShops()
    @searchAutoComplete()
    @bindEvents()

    @init()

  init: ->
    if !@isBrowserSupportGeoLocation()
      @geolocationBtn.hide()

  bindEvents: ->

    google.maps.event.addListener @map, 'click', =>
      @stopBounceMarker()
      @infowindow.close()

    google.maps.event.addListener @infowindow, 'closeclick', =>
      @stopBounceMarker()


    google.maps.event.addListener @map, 'idle', =>
      @renderSideBar()

    @shopList.on "mouseover", ".shop-list-item", (event)=>
      @handleMouseOverShopListItem(event.currentTarget)
    @shopList.on "mouseleave", ".shop-list-item", (event)=>
      @handleMouseLeaveShopListItem(event.currentTarget)
    @shopList.on "click", ".shop-list-item", (event)=>
      @handleClickShopListItem(event.currentTarget)


    @freeWifiSwitch.on "switch-change", =>
      @handleSwitchChange()

    @freePowerOutlets.on "switch-change", =>
      @handleSwitchChange()




    @geolocationBtn.on "click", =>
      @geoLocation()

  initialMapElemant: ->
    style = [
        {
            "featureType": "water",
            "stylers": [
                {
                    "color": "#19a0d8"
                }
            ]
        },
        {
            "featureType": "administrative",
            "elementType": "labels.text.stroke",
            "stylers": [
                {
                    "color": "#ffffff"
                },
                {
                    "weight": 4
                }
            ]
        },
        {
            "featureType": "administrative",
            "elementType": "labels.text.fill",
            "stylers": [
                {
                    "color": "#e85113"
                }
            ]
        },
        {
            "featureType": "road.highway",
            "elementType": "geometry.stroke",
            "stylers": [
                {
                    "color": "#efe9e4"
                },
                {
                    "lightness": -40
                }
            ]
        },
        {
            "featureType": "road.arterial",
            "elementType": "geometry.stroke",
            "stylers": [
                {
                    "color": "#efe9e4"
                },
                {
                    "lightness": -20
                }
            ]
        },
        {
            "featureType": "road",
            "elementType": "labels.text.stroke",
            "stylers": [
                {
                    "lightness": 100
                }
            ]
        },
        {
            "featureType": "road",
            "elementType": "labels.text.fill",
            "stylers": [
                {
                    "lightness": -100
                }
            ]
        },
        {
            "featureType": "road.highway",
            "elementType": "labels.icon"
        },
        {
            "featureType": "landscape",
            "elementType": "labels",
            "stylers": [
                {
                    "visibility": "off"
                }
            ]
        },
        {
            "featureType": "landscape",
            "stylers": [
                {
                    "lightness": 20
                },
                {
                    "color": "#efe9e4"
                }
            ]
        },
        {
            "featureType": "landscape.man_made",
            "stylers": [
                {
                    "visibility": "off"
                }
            ]
        },
        {
            "featureType": "water",
            "elementType": "labels.text.stroke",
            "stylers": [
                {
                    "lightness": 100
                }
            ]
        },
        {
            "featureType": "water",
            "elementType": "labels.text.fill",
            "stylers": [
                {
                    "lightness": -100
                }
            ]
        },
        {
            "featureType": "poi",
            "elementType": "labels.text.fill",
            "stylers": [
                {
                    "hue": "#11ff00"
                }
            ]
        },
        {
            "featureType": "poi",
            "elementType": "labels.text.stroke",
            "stylers": [
                {
                    "lightness": 100
                }
            ]
        },
        {
            "featureType": "poi",
            "elementType": "labels.icon",
            "stylers": [
                {
                    "hue": "#4cff00"
                },
                {
                    "saturation": 58
                }
            ]
        },
        {
            "featureType": "poi",
            "elementType": "geometry",
            "stylers": [
                {
                    "visibility": "on"
                },
                {
                    "color": "#f0e4d3"
                }
            ]
        },
        {
            "featureType": "road.highway",
            "elementType": "geometry.fill",
            "stylers": [
                {
                    "color": "#efe9e4"
                },
                {
                    "lightness": -25
                }
            ]
        },
        {
            "featureType": "road.arterial",
            "elementType": "geometry.fill",
            "stylers": [
                {
                    "color": "#efe9e4"
                },
                {
                    "lightness": -10
                }
            ]
        },
        {
            "featureType": "poi",
            "elementType": "labels",
            "stylers": [
                {
                    "visibility": "simplified"
                }
            ]
        }
    ]


    mapOptions = {
      zoom: 8
      center: new google.maps.LatLng(23.64, 121.01)
      styles: style
    }

    @map = new google.maps.Map(@container[0], mapOptions)
    @infowindow = new google.maps.InfoWindow

    cluster_options = {
      maxZoom: 15,
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
          fontFamily: 'Playball'
        }
      ]
    }
    @markerClusterer = new MarkerClusterer(@map, [], cluster_options)

    @hereMarker = new google.maps.Marker

  initialTemplates: ->
    source   = $("#shop-detail-template").html()
    @shop_detail_template = Handlebars.compile(source)
    source   = $("#shop-list-item-template").html()
    @shop_list_item_template = Handlebars.compile(source)


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

    # Preload
    @infowindow.setOptions {
      content: @shop_detail_template({
        name: marker.title
        is_wifi_free: marker.is_wifi_free
        power_outlets: marker.power_outlets
      })
    }
    @infowindow.open(@map, marker)



    $.ajax {
      url: "#{@shop_api_endpoint}/#{marker_id}",
      data: {},
      dataType: "json"
      success: (data)=>

        @infowindow.setOptions {
          content: @shop_detail_template(data)
        }

        @infowindow.open(@map, marker)


        $(".avg-rating-container").raty({
          half: true
          number: 5,
          path: "/images/raty/",
          readOnly  : true,
          score: data.avg_rating
        })


        $(".user-rating-container").raty({
          half: true
          number: 5,
          path: "/images/raty/",
          cancel: true
          score: data.user_rating,
          cancelPlace: 'right',
          click: (score)=>
            if score == null
              $.ajax {
                type: "delete"
                url: "#{@shop_api_endpoint}/#{marker_id}/cancel_rating",
                dataType: "script"
              }
            else
              $.ajax {
                type: "put"
                url: "#{@shop_api_endpoint}/#{marker_id}/rating",
                data: {score: score},
                dataType: "script"
              }
        })
    }




  handleSwitchChange: ->
    filterOption = {}

    if @freeWifiSwitch.bootstrapSwitch("status") == true
      filterOption.is_wifi_free = true

    if @freePowerOutlets.bootstrapSwitch("status") == true
      filterOption.power_outlets = true

    if _.size(filterOption) > 0
      result = _.where(@markers(), filterOption)
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
  
  isBrowserSupportGeoLocation: ->
    geoPosition.init()

  geoLocationLoading: ->
    @geolocationBtn.addClass("loading")

  geoLocation: ->
    if @isBrowserSupportGeoLocation()
      @geoLocationLoading()
      geoPosition.getCurrentPosition(@handleGeoLocationSuccess, @handleGeoLocationError,{enableHighAccuracy:true})

  handleGeoLocationSuccess: (p)=>
    @geolocationBtn.removeClass("loading")

    lat = p.coords.latitude
    lng = p.coords.longitude
    location = new google.maps.LatLng(lat, lng)

    @placeHereMarker(location)
    @moveToLocation(location)
    @zoomIn()
  handleGeoLocationError: =>
    @geolocationBtn.removeClass("loading")


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
  placeHereMarker: (location)->
    @hereMarker.setOptions({
      position: location,
      map: @map,
      title: "You are here!",
      icon: "/images/here-icon.png"
    })

  bounceMarker: (marker)->
    @stopBounceMarker()
    
    if marker.map
      @animationMarker = marker
      marker.setAnimation(google.maps.Animation.BOUNCE)
    else
      cluster = @markerCluster(marker)
      $clusterIcon = $(cluster.clusterIcon_.div_)
      $clusterIcon.addClass("hover")


  stopBounceMarker: (marker)->
    @animationMarker.setAnimation(null) if @animationMarker

    if marker && !marker.map
      cluster = @markerCluster(marker)
      $clusterIcon = $(cluster.clusterIcon_.div_)
      $clusterIcon.removeClass("hover")

  renderSideBar: ->

    @shopList.html("")

    counter = 1

    for marker in @markersInView()
      $html = $(@shop_list_item_template(marker))
      $html.data("marker", marker)
      @shopList.append($html)

      if counter < 20
        counter++
      else
        break
  handleMouseOverShopListItem: (target)->
    $target = $(target)
    marker = $target.data("marker")


    @bounceMarker(marker)

  handleMouseLeaveShopListItem: (target)->
    $target = $(target)
    marker = $target.data("marker")

    @stopBounceMarker(marker)

  handleClickShopListItem: (target)->
    $target = $(target)
    marker = $target.data("marker")

    @handleMarkerClick(marker)

    
  markers: ->
    @markerClusterer.getMarkers()

  markersInView: ->
    result = []
    bounds = @map.getBounds()
    
    for marker in @markers()
      result.push(marker) if bounds.contains(marker.getPosition())

    return result

  markerCluster: (marker)->
    clusters = @markerClusterer.getClusters()
    
    for cluster in clusters
      return cluster if cluster.isMarkerInClusterBounds(marker)


  findMarkerById: (id)->
    for marker in @markers()
      return marker if marker.id == id


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

    window.c = mapPreviewer