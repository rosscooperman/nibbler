$LAB.script('http://www.google.com/jsapi').wait ->
  google.load("maps", "3", {
    other_params: "sensor=false"
    callback: ->
      $(window).trigger('nibbler:maps:load')
  })

class window.Map
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

  constructor:(selector, lat, lng) ->
    @markers = []
    @center  = new google.maps.LatLng(lat, lng)
    @map     = new google.maps.Map $(selector).get(0), this.mapOptions()

    @markerImage = $(selector).data('markers')
    @markerSize  = new google.maps.Size(27, 36)

  clearMarkers: =>
    $.each @markers, ->
      this.setMap(null)

  addMarker:(lat, lng) =>
    origin = new google.maps.Point(0, @markers.length * 100)
    image  = new google.maps.MarkerImage(@markerImage, @markerSize, origin)
    marker = new google.maps.Marker({
      map:      @map
      position: new google.maps.LatLng(lat, lng)
      icon:     image
    })
    @markers.push(marker)

  zoomToPoint:(lat, lng) =>
    @map.setCenter(new google.maps.LatLng(lat, lng))
    @map.setZoom(16)

  resetBounds: =>
    bounds = new google.maps.LatLngBounds
    $.each @markers, ->
      bounds.extend(this.getPosition())
    @map.fitBounds(bounds)

