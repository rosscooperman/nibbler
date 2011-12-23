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

  constructor:(selector, lat, lng) ->
    latlng = new google.maps.LatLng(lat, lng)
    @markers = []
    @map = new google.maps.Map $(selector).get(0), {
      zoom:        10
      center:      latlng
      mapTypeId:   google.maps.MapTypeId.ROADMAP
      panControl:  true
      scrollwheel: false
      styles:      this.mapStyles()
    }

  clearMarkers: =>
    $.each @markers, ->
      this.setMap(null)

  addMarker:(lat, lng) =>
    @markers.push(new google.maps.Marker({map: @map, position: new google.maps.LatLng(lat, lng)}))

  zoomToPoint:(lat, lng) =>
    @map.setCenter(new google.maps.LatLng(lat, lng))
    @map.setZoom(16)

  resetBounds: =>
    bounds = new google.maps.LatLngBounds
    $.each @markers, ->
      bounds.extend(this.getPosition())
    @map.fitBounds(bounds)

