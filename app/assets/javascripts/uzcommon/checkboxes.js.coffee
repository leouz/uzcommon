$(document).ready ->  
  timeOutFunc = -> 
    $(window).resize()      

    customizeCheckboxesAndRadios = ->
      $('input[type=radio], input[type=checkbox]').each ->        
        $this = $(this)        
        type = $this.attr('type')

        if !$this.hasClass("#{type}-customized")
          $this.addClass("#{type}-customized")
          element = $("<div class=\"#{type}-image\" />")      
          element.addClass("checked") if $this.is(":checked")
          $this.after element
          $this.hide 0
          if type == "radio"
            $this.change ->
              if $(this).is(":checked")
                $(".radio-image", $this.parent()).addClass("checked")
          else
            $this.change ->
              if $(this).is(":checked")
                $(".checkbox-image", $this.parent()).addClass("checked")
              else
                $(".checkbox-image", $this.parent()).removeClass("checked")

    customizeCheckboxesAndRadios()

  setTimeout timeOutFunc, 200
  $(window).resize()
