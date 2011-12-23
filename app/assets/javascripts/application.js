//= require LAB
//= require jquery
//= require jquery_ujs
//= require jquery.colorbox-min
//= require foundation
//= require app
//= require handlebars
//= require map
//= require mapping

$(function() {

  function toggleResults() {
    var righty = $(this).next();
		righty.animate({
		  right: (parseInt(righty.css('right'), 10) == 0) ? -righty.outerWidth() : 0
		});
    $('button.showResults').fadeIn();
  }


  function renderResults(data) {
    var source   = $('#result-template').html();
    var template = Handlebars.compile(source);
    var target   = $('ul.results');
    var mapIndex = 'A'.charCodeAt(0);

    $.each(data, function() {
      var html = template({ truck: this, mapIndex: String.fromCharCode(mapIndex++) });
      target.append(html);
    });
  }


  function handleSearch(event) {
	  event.preventDefault();
    window.theMap.clearMarkers();

	  var form = $(this);
	  var query = form.find('input[name=q]').val();

	  $.ajax({
	    url:      form.attr('action'),
	    data:     form.serialize(),
	    method:   'GET',
	    dataType: 'json',
	    success:  function(data, status, xhr) {
	      window.theMap.clearMarkers();
	      $.each(data, function() {
  	      window.theMap.addMarker(this.location.lat, this.location.lng);
  	      //window.theMap.zoomToPoint(this.location.lat, this.location.lng);
	      });
	      window.theMap.resetBounds();
	      renderResults(data);
	      $('input[name=q]').val(query);
        $('.noobSearch').fadeOut(300);
        $('.logoMarker').fadeOut(900);
        $('.topWrapper').slideDown('slow');
        $('button.showResults').click();
	    },
	    error:    function(xhr, status, error) {
	      console.log(error);
				$('.noobSearch').fadeOut(300);
        $('.logoMarker').fadeOut(900);
        $('.topWrapper').slideDown('slow');
	    }
	  });
  }


  function handleClick(event) {
    event.preventDefault();
    $(this).closest('form').submit();
  }


  // handle clicks on the search button(s) and submission of the search form(s)
	$('.searchButton').click(handleClick);
	$('.noobSearch form, .topContainer form').submit(handleSearch);


	// slide the results in from the right
	$('button.showResults').click(toggleResults);
});
