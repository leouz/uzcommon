$(document).ready(function() {  
  $(window).resize(function () {
    var $p = $('.proportional-height');
    $p.css('height', ($p.width()/100) * 70);

    $('.same-height').each(function () {
      $(this).css('height', $(this).width());
    });
    
  });  
  $(window).resize();
});