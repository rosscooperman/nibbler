jQuery ->
  $(window).bind 'nibbler:maps:load', ->
    map = new window.Map('#fullMap', 40.735812, -73.796539)
    # $('.bar-list').bind 'gi:loaded', -> map.addMarkers()
