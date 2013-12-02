class LandingMap
  constructor: (@container) ->
    @shop_api_endpoint = Setting.shop_api_endpoint

    @initialMapElemant()

    @queryShops()


  initialMapElemant: ->
    mapOptions = {
      zoom: 8
      center: new google.maps.LatLng(23.84, 121.01)
    }

    @map = new google.maps.Map(@container[0], mapOptions);

  queryShops: ->

    $.ajax {
      url: @shop_api_endpoint,
      data: {},
      success: @handleReturnData,
      dataType: "json"
    }

  handleReturnData: (data)->
    console.log(data)


$ ->
  if $(".landing-map").length > 0
    mapPreviewer = new LandingMap($(".landing-map"))