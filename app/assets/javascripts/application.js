//= require jquery
//= require jquery_ujs
//= require jquery.colorbox-min
//= require foundation
//= require app
//= require map

$(document).ready(function(){
	
	$('.searchButton').click(function(){
		$('.noobSearch').fadeOut(300);
		$('.logoMarker').fadeOut(900);
		$('.topWrapper').slideDown('slow');
	});

});

