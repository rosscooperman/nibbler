jQuery ->
  $(window).bind 'nibbler:maps:load', ->
    window.theMap = new window.Map('#fullMap', 40.735812, -73.796539)
