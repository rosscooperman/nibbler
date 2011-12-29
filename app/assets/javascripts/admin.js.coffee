jQuery ->
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