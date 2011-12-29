class SetBounds
  constructor:(map) ->
    @map = map.googleMap()

    bounds = @map.getBounds()
    if $('#truck_bounds_ne_lat').val() != ""
      ne_lat = parseFloat($('#truck_bounds_ne_lat').val())
      ne_lng = parseFloat($('#truck_bounds_ne_lng').val())
      sw_lat = parseFloat($('#truck_bounds_sw_lat').val())
      sw_lng = parseFloat($('#truck_bounds_sw_lng').val())
      ne = new google.maps.LatLng(ne_lat, ne_lng)
      sw = new google.maps.LatLng(sw_lat, sw_lng)
      bounds = new google.maps.LatLngBounds(sw, ne)

    @rect = new google.maps.Rectangle({
      map:           @map
      bounds:        bounds
      fillColor:     'black'
      strokeColor:   'black'
      fillOpacity:   0.25
      strokeOpacity: 0.5
      strokeWeight:  1
    })


  updateBounds: =>
    bounds = @rect.getBounds()
    $('#truck_bounds_ne_lat').val(bounds.getNorthEast().lat())
    $('#truck_bounds_ne_lng').val(bounds.getNorthEast().lng())
    $('#truck_bounds_sw_lat').val(bounds.getSouthWest().lat())
    $('#truck_bounds_sw_lng').val(bounds.getSouthWest().lng())


  isEditing: =>
    @_isEditing ?= false


  startEditing: =>
    @_isEditing = true
    @rect.setEditable(true)


  stopEditing: =>
    @_isEditing = false
    @rect.setEditable(false)
    this.updateBounds()


jQuery ->
  map       = null
  setBounds = null

  $(window).bind 'nibbler:maps:load', ->
    if $('#theMap').size() > 0
      map = new window.Map('#theMap', 40.735812, -73.796539)
      $('#main_content').find('.coordinates > li').each ->
        llArray = $(this).html().split(/,/)
        map.addMarker parseFloat(llArray[0]), parseFloat(llArray[1])
      map.resetBounds()

    if $('#truck_bounds_ne_lat').val()
      setBounds = new SetBounds(map)
      $('#truck_collection_bounding_area').find('input[type=button]').val('Edit Bounds')

    $('#truck_collection_bounding_area').find('input[type=button]').click ->
      setBounds = new SetBounds(map) if setBounds == null
      button = $(this)
      if setBounds.isEditing()
        setBounds.stopEditing()
        button.val('Edit Bounds')
      else
        setBounds.startEditing()
        button.val('Done!')
