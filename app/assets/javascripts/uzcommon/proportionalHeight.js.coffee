window.proportionalHeight = () ->
  for factor in [10, 20, 30, 40, 50, 60, 70, 90, 100]
    $(".proportional-height-#{factor}").each ->
      $this = $(this)
      $this.css "height", ($this.width() / 100) * factor

  $(".proportional-height").each ->
    $this = $(this)
    $this.css "height", ($this.width() / 100) * 70

  $(".same-height").each ->
    $this = $(this)
    $this.css "height", $this.width()      

$(document).ready ->
  $(window).resize ->   
    window.proportionalHeight()     

  $(window).resize()  
