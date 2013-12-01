class MapPreviewer
  constructor: (@container) ->
    

$ ->
  if $(".map-preview").length > 0
    map_previewer = new MapPreviewer($(".map-preview"))
