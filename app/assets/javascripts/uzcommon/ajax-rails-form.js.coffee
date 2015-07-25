(($) ->

  $.fn.ajaxRailsForm = (options) ->
    t = this
    $t = $(t)

    t.options = $.extend({
      errorsSelector: '.errors'
      formGroupSelector: '.form-group'
      errorClass: 'has-error'
      useBootbox: true
      addErrorsToForm: true
      error: -> true
      success: -> true
    }, options)

    t.resetForm = ->
      $('input[type=text], input[type=password], input[type=email], select, textarea', $t).val('')

    t.resetValidation = ->
      $(t.options.errorsSelector, $t).empty()
      $(t.options.formGroupSelector, $t).removeClass(t.options.errorClass)

    t.handleResponse = (result, data) ->      
      t.resetValidation($t)

      if data.alert
        if t.options.useBootbox
          bootbox.alert data.alert
        else
          alert data.alert

      if data.redirect_to
        window.location = data.redirect_to

      if data.errors
        $ul = $('<ul>') if t.options.addErrorsToForm
        for property of data.errors
          if data.errors.hasOwnProperty(property)            
            $("#{t.options.formGroupSelector}[for=#{property}]", $t).addClass("has-error")         
            $ul.append($('<li>').html(data.errors[property])) if t.options.addErrorsToForm and data.errors[property] != null
        
        if t.options.addErrorsToForm
          $errors = $(t.options.errorsSelector, $t)
          $errors.append($ul)

      if result
        t.options.success()
      else
        t.options.error()
    
    $t.ajaxForm
      type: 'POST'            
      success: (data) ->        
        t.resetForm()
        t.handleResponse(true, data)
      error: (xhr) ->                  
        t.handleResponse(false, xhr.responseJSON)

) jQuery
