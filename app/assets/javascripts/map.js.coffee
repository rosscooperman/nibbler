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

    @markerImage = $(selector).data('markers')
    @markerSize  = new google.maps.Size(27, 36)


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


  addMarker:(lat, lng) =>
    options = {
      map:      @map
      position: new google.maps.LatLng(lat, lng)
    }
    options.icon = new google.maps.MarkerImage(@markerImage, @markerSize) if @markerImage

    marker = new google.maps.Marker(options)
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

