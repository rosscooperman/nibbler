function yellowFade() {
  setTimeout("new Effect.Highlight('<%= flash[:highlight] %>');", 100); // 0.1 seconds
}

// opens all links with rel="external" in a new window
var bindToExternalLinks = function() {
  $("a[rel='external']").live('click', function(){
    return !window.open(this.href);
  });
};

$('document').ready(function() {
  bindToExternalLinks();
  $.nyroModalSettings({
    galleryLinks: ''
  });

  // for pagination
  $("a.go_to_page").click(function() {
    $(this).toggle();
    $('div.go_to_page').toggleClass('display');
  });
});
