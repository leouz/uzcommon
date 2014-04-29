$(document).ready(function() {  
  $(window).resize(function () {
    var $e = $('.proportional-height');
    $e.css('height', ($e.width()/100) * 70);
  });  
  $(window).resize();
});