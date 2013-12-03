class LandingMap
  constructor: (@container) ->
    @shop_api_endpoint = Setting.shop_api_endpoint
    @mapSideBar = $(".map-sidebar")
    @shopDetail = $(".shop-detail") 


    @bindEvents()
    @initialMapElemant()
    @initialShopDetailTemplate()
    @queryShops()


  bindEvents: ->
    @mapSideBar.find(".close").click =>
      @hideSideBar()


  initialMapElemant: ->
    mapOptions = {
      zoom: 8
      center: new google.maps.LatLng(23.64, 121.01)
    }

    @map = new google.maps.Map(@container[0], mapOptions);

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
      }

      marker = new google.maps.Marker(markerOptions)
      marker.setValues({
        id: shop.id
      });


      google.maps.event.addListener marker, 'click', ->
        that.handleMarkerClick(this)

  handleMarkerClick: (marker) ->
    marker_id = marker.get("id")

    $.ajax {
      url: "#{@shop_api_endpoint}/#{marker_id}",
      data: {},
      dataType: "json"
      success: (data)=>
        @showSideBar()
        @shopDetail.html(@shop_detail_template(data))
    }

  showSideBar: ->
    @mapSideBar.addClass("active")

  hideSideBar: ->
    @mapSideBar.removeClass("active")


$ ->
  if $(".shop-map").length > 0
    mapPreviewer = new LandingMap($(".shop-map"))