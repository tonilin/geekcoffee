class LandingMap
  constructor: (@container) ->
    @shop_api_endpoint = Setting.shop_api_endpoint
    @mapSideBar = $(".map-sidebar")
    @shopDetail = $(".shop-detail") 
    @mapContainer = $(".map-container")
    @markers = []


    @initialMapElemant()
    @initialShopDetailTemplate()
    @queryShops()
    @bindEvents()

  bindEvents: ->

    google.maps.event.addListener @map, 'click', =>
      @stopBounceMarker()
      @infowindow.close()

    google.maps.event.addListener @infowindow, 'closeclick', =>
      @stopBounceMarker()


  initialMapElemant: ->
    mapOptions = {
      zoom: 8
      center: new google.maps.LatLng(23.64, 121.01)
    }

    @map = new google.maps.Map(@container[0], mapOptions);
    @infowindow = new google.maps.InfoWindow


    cluster_options = {
      maxZoom: 18,
      styles: [
        {
          anchorIcon: [32, 32]
          anchorText: [10, -4]
          height: 64,
          url: "/images/cluster.png",
          width: 64,
          textColor: "#FFFFFF",
          fontWeight: "normal"
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
        icon: "/images/coffee.png"
      }

      marker = new google.maps.Marker(markerOptions)
      marker.setValues({
        id: shop.id
      });

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

$ ->
  if $(".shop-map").length > 0
    mapPreviewer = new LandingMap($(".shop-map"))