$(document).ready ->
  $(window).resize ->    
    for factor in [10, 20, 30, 40, 50, 60, 70, 90, 100]
      $e = $(".proportional-height-#{factor}")
      $e.css "height", ($e.width() / 100) * factor
  
    $p = $(".proportional-height")
    $p.css "height", ($p.width() / 100) * 70

    $(".same-height").each ->
      $(this).css "height", $(this).width()      

  $(window).resize()  
