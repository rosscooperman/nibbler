jQuery ->
  $(window).bind 'nibbler:maps:load', ->
    if $('#theMap').size() > 0
      map = new window.Map('#theMap', 40.735812, -73.796539)
      $('#main_content').find('.coordinates > li').each ->
        llArray = $(this).html().split(/,/)
        map.addMarker parseFloat(llArray[0]), parseFloat(llArray[1])
      map.resetBounds()

  autoPopulation = ""
  $('#truck_source').change ->
    newSource = $(this).val()

    console.log autoPopulation
    console.log $('#truck_source_data').val()
    if $('#truck_source_data').val() == autoPopulation
      newData = switch newSource
        when ""                   then ""
        when "Collector::Twitter" then "@"
        when "Collector::Website" then """
                                       url: ...
                                       location_selector: ...
                                       location_regex: ...
                                       location_parts: [ ... ]
                                       time_selector: ...
                                       time_regex: ...
                                       time_parts: [ ... ]
                                       """

      autoPopulation = newData
      $('#truck_source_data').val(newData)