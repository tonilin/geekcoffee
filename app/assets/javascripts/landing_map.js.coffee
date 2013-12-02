class LandingMap
  constructor: (@container) ->
    @initialMapElemant()

  initialMapElemant: ->
    mapOptions = {
      zoom: 8
      center: new google.maps.LatLng(23.84, 121.01)
    }

    @map = new google.maps.Map(@container[0], mapOptions);


$ ->
  if $(".landing-map").length > 0
    mapPreviewer = new LandingMap($(".landing-map"))