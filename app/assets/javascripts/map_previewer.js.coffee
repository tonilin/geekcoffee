class MapPreviewer
  constructor: (@container) ->
    mapOptions = {
      zoom: 7,
      center: new google.maps.LatLng(23.84, 121.01)
    }

    map = new google.maps.Map(@container[0], mapOptions);

$ ->
  if $(".map-preview").length > 0
    mapPreviewer = new MapPreviewer($(".map-preview"))
