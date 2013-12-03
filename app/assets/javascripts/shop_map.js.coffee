class LandingMap
  constructor: (@container) ->
    @shop_api_endpoint = Setting.shop_api_endpoint

    @initialMapElemant()

    @queryShops()


  initialMapElemant: ->
    mapOptions = {
      zoom: 8
      center: new google.maps.LatLng(23.64, 121.01)
    }

    @map = new google.maps.Map(@container[0], mapOptions);

  queryShops: ->

    $.ajax {
      url: @shop_api_endpoint,
      data: {},
      success: @handleReturnData,
      dataType: "json"
    }

  handleReturnData: (data)=>
    shops = data.shops

    for shop in shops
      markerOptions = {
        position: new google.maps.LatLng(shop.lat, shop.lng),
        map: @map,
        title: shop.name,
        icon: "/images/coffee.png",
      }
      marker = new google.maps.Marker(markerOptions)
      marker.setValues({id: shop.id});

$ ->
  if $(".shop-map").length > 0
    mapPreviewer = new LandingMap($(".shop-map"))