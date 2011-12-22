jQuery ->
  $(window).bind 'nibbler:maps:load', ->
    map = new Map('.map', 40.735812, -73.796539)
    $('#main_content').find('.coordinates > li').each ->
      llArray = $(this).html().split(/,/)
      map.addMarker parseFloat(llArray[0]), parseFloat(llArray[1])
    map.resetBounds()
