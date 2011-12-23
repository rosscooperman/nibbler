//= require LAB
//= require jquery
//= require jquery_ujs
//= require jquery.colorbox-min
//= require foundation
//= require app
//= require map
//= require mapping

$(document).ready(function(){

	$('.searchButton').click(function() {
	  var form = $('.noobSearch form');
	  $.ajax({
	    url:      form.attr('action'),
	    data:     form.serialize(),
	    method:   'GET',
	    dataType: 'json',
	    success:  function(data, status, xhr) {
	      $.each(data, function() {
  	      window.theMap.addMarker(this.location.lat, this.location.lng);
  	      window.theMap.zoomToPoint(this.location.lat, this.location.lng);
	      });
        $('.noobSearch').fadeOut(300);
        $('.logoMarker').fadeOut(900);
        $('.topWrapper').slideDown('slow');
	    },
	    error:    function(xhr, status, error) {
	      console.log(error);
	    }
	  });
	});

	// slide the results in from the right
	$('button.showResults').click(function() {
	    var $righty = $('.results');
		    $righty.animate({
		      right: parseInt($righty.css('right'),10) == 0 ? -$righty.outerWidth() : 0 });
	  });
	
});
