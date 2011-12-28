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

  function renderResults(data) {
    var source   = $('#result-template').html();
    var template = Handlebars.compile(source);
    var target   = $('.growlWrapper');
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
	      });
	      window.theMap.resetBounds();
	      renderResults(data);
	      $('input[name=q]').val(query);
        $('.noobSearch').fadeOut(300);
        $('.logoMarker').fadeOut(900);
        $('.topWrapper').slideDown('slow');
	    },
	    error:    function(xhr, status, error) {
	      //TODO implement some real error handling here
	      console.log(error);
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


  $(window).bind("nibbler:marker:mouseover", function(event) {
    var notifiers = $('.growlWrapper .growlNotify');
    var notifier  = $(notifiers.get(event.which));
    notifier.stop(true, true).animate({ opacity: "toggle", top: '-=50' }, 400);
  });

  $(window).bind("nibbler:marker:mouseout", function(event) {
    var notifiers = $('.growlWrapper .growlNotify');
    var notifier  = $(notifiers.get(event.which));
    notifier.stop(true, true).animate({ opacity: "toggle", top: '+=100' }, 800, function() {
      notifier.removeAttr('style');
      return false;
    });
  });


	// on hover show growlNotify
	$('.growlclk').hover(function(){
		$('.growlNotify')
			.stop(true, true)
			.animate({
		   	opacity: "toggle",
		    top: '-=50',
		  }, 400);
	}, function(){
		$('.growlNotify').stop(true, true).animate({
		    opacity: 'toggle',
		    top: '+=100',
		  }, 800, 	function(){
				$('.growlNotify').removeAttr('style');
				return false;
				});
	});


$('.truckListBttn').click(function(){
	$('.truckContainer').slideToggle('slow');
});




}); //ends document load
