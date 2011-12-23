//= require LAB
//= require jquery
//= require jquery_ujs
//= require jquery.colorbox-min
//= require foundation
//= require app
//= require map
//= require mapping

$(document).ready(function(){

	$('.searchButton').click(function(){
		$('.noobSearch').fadeOut(300);
		$('.logoMarker').fadeOut(900);
		$('.topWrapper').slideDown('slow');
	});

	// slide the results in from the right
	$('button.showResults').click(function() {
	    var $righty = $('.results');
		    $righty.animate({
		      right: parseInt($righty.css('right'),10) == 0 ? -$righty.outerWidth() : 0 });
	  });
	
});
