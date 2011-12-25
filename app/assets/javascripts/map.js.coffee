# a little bit of code to load up the Google Maps API and fire a jQuery event when
# it has loaded successfully (so other code can start using the below map class)
$LAB.script('http://www.google.com/jsapi').wait ->
  google.load("maps", "3", {
    other_params: "sensor=false"
    callback: ->
      $(window).trigger('nibbler:maps:load')
  })

class window.Map
  constructor:(selector, lat, lng) ->
    @markers = []
    @center  = new google.maps.LatLng(lat, lng)
    @map     = new google.maps.Map $(selector).get(0), this.mapOptions()

    image  = $(selector).data('markers')

    if image
      origin            = new google.maps.Point(0, 0)
      size              = new google.maps.Size(25, 39)
      @markerImage      = new google.maps.MarkerImage(image, size, origin)

      origin            = new google.maps.Point(0, 91)
      size              = new google.maps.Size(33, 49)
      @markerImageLarge = new google.maps.MarkerImage(image, size, origin)


  mapStyles: ->
    [
      {
        featureType: "poi"
        stylers:     [ { visibility: "off" } ]
      },
      {
        featureType: "poi.park"
        stylers:     [ { visibility: "on" } ]
      },
      {
        featureType: "administrative"
        stylers:     [ { visibility: "off" } ]
      },
      {
        featureType: "transit.station.bus"
        stylers:     [ { visibility: "off" } ]
      },
      {
        featureType: "road.arterial"
        stylers:     [ { lightness: 63 }, { visibility: "on" } ]
      },
      {
        featureType: "transit.station.rail"
        elementType: "labels"
        stylers:     [ { visibility: "on" }, { saturation: -24 } ]
      }
    ]


  mapOptions:(center) ->
    {
      zoom:           10
      center:         @center
      mapTypeId:      google.maps.MapTypeId.ROADMAP
      panControl:     true
      scrollwheel:    false
      styles:         this.mapStyles()
      mapTypeControl: false
      panControlOptions: {
        position: google.maps.ControlPosition.LEFT_CENTER
      }
      zoomControlOptions: {
        position: google.maps.ControlPosition.LEFT_CENTER
      }
    }


  clearMarkers: =>
    $.each @markers, ->
      this.setMap(null)
    @markers = []


  markerMouseOver:(event) =>
    return unless @markerImageLarge

    eventLat = parseFloat(event.latLng.lat().toFixed(3))
    eventLng = parseFloat(event.latLng.lng().toFixed(3))
    image    = @markerImageLarge

    $.each @markers, ->
      lat = parseFloat(this.getPosition().lat().toFixed(3))
      lng = parseFloat(this.getPosition().lng().toFixed(3))
      if eventLat == lat && eventLng = lng
        this.setIcon(image)


  markerMouseOut:(event) =>
    return unless @markerImageLarge

    eventLat = parseFloat(event.latLng.lat().toFixed(3))
    eventLng = parseFloat(event.latLng.lng().toFixed(3))
    image    = @markerImage

    $.each @markers, ->
      lat = parseFloat(this.getPosition().lat().toFixed(3))
      lng = parseFloat(this.getPosition().lng().toFixed(3))
      if eventLat == lat && eventLng = lng
        this.setIcon(image)


  addMarker:(lat, lng) =>
    options = {
      map:      @map
      position: new google.maps.LatLng(lat, lng)
    }
    options.icon = @markerImage if @markerImage

    marker = new google.maps.Marker(options)
    google.maps.event.addListener(marker, 'mouseover', this.markerMouseOver)
    google.maps.event.addListener(marker, 'mouseout', this.markerMouseOut)
    @markers.push(marker)


  zoomToPoint:(ll_or_lat, lng) =>
    ll = if lng then new google.maps.LatLng(ll_or_lat, lng) else ll_or_lat
    @map.setCenter(ll)
    @map.setZoom(16)


  resetBounds: =>
    if @markers.length == 1
      this.zoomToPoint(@markers[0].getPosition())
    else
      bounds = new google.maps.LatLngBounds
      $.each @markers, ->
        bounds.extend(this.getPosition())
      @map.fitBounds(bounds)

