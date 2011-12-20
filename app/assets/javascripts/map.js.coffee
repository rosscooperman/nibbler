class Map
  constructor: ->
    latlng = new google.maps.LatLng(40.735812, -73.796539)
    @map = new google.maps.Map $('#fullMap').get(0), {
      zoom:        10
      center:      latlng
      mapTypeId:   google.maps.MapTypeId.ROADMAP
      panControl:  true
      scrollwheel: false
      styles: [
        {
          featureType: "poi"
          stylers: [
            { visibility: "off" }
          ]
        },
        {
          featureType: "poi.park",
          stylers: [
            { visibility: "on" }
          ]
        },
        {
          featureType: "administrative",
          stylers: [
            { visibility: "off" }
          ]
        },
        {
          featureType: "transit.station.bus",
          stylers: [
            { visibility: "off" }
          ]
        },
        {
          featureType: "road.arterial",
          stylers: [
            { lightness: 63 },
            { visibility: "on" }
          ]
        },
        {
          featureType: "transit.station.rail",
          elementType: "labels",
          stylers: [
            { visibility: "on" },
            { saturation: -24 }
          ]
        }
      ]
    }

  addMarkers: =>
    markers    = $('.bar-list').data('markers')
    markerSize = new google.maps.Size(20, 34)
    map        = @map

    $('.bar-list > li').each ->
      offset = $(this).find('.map-index').html().charCodeAt(0) - 65
      latlng = new google.maps.LatLng parseFloat($(this).data('lat')), parseFloat($(this).data('lng'))
      origin = new google.maps.Point(0, offset * 34)
      marker = new google.maps.MarkerImage(markers, markerSize, origin)
      new google.maps.Marker {
        map:      map
        position: latlng
        icon:     marker
      }

jQuery ->
  map = new Map
  # $('.bar-list').bind 'gi:loaded', -> map.addMarkers()