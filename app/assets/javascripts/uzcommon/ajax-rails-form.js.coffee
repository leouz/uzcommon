(($) ->

  $.fn.ajaxRailsForm = (options) ->
    t = this
    $t = $(t)

    t.options = $.extend({
      errorsSelector: '.form-group .errors'
      formGroupSelector: '.form-group'
      errorClass: 'has-error'      
      addErrorsToForm: true
      showSuccessMessageInBootbox: false
      showErrorMessageInBootbox: true
      error: -> true
      success: -> true
    }, options)

    t.resetForm = ->
      $('input[type=text], input[type=password], input[type=email], select, textarea', $t).val('')

    t.resetValidation = ->
      $(t.options.errorsSelector, $t).remove()
      $(t.options.formGroupSelector, $t).removeClass(t.options.errorClass)

    t.executeEvents = (result, data) ->
      if result
        t.options.success(data)
      else
        t.options.error(data)

    t.handleResponse = (result, data) ->      
      t.resetValidation($t)

      if data.errors        
        for property of data.errors
          if data.errors.hasOwnProperty(property)            
            $("#{t.options.formGroupSelector}[for=#{property}]", $t).addClass("has-error")
            if t.options.addErrorsToForm
              $errors = $('<div>').addClass('errors')
              for e in data.errors[property]   
                $errors.append($('<p>').addClass('help-block').html(e))
              $("#{t.options.formGroupSelector}[for=#{property}]", $t).append($errors)

      messageShown = false
      if data.message
        if result and t.options.showSuccessMessageInBootbox          
          bootbox.alert data.message, () -> t.executeEvents(result, data)
          messageShown = true
        if (!result) and t.options.showErrorMessageInBootbox
          bootbox.alert data.message, () -> t.executeEvents(result, data)
          messageShown = true
      
      t.executeEvents(result, data) if !messageShown
    
    $t.ajaxForm
      type: 'POST'            
      success: (data) ->        
        t.resetForm()
        t.handleResponse(true, data)
      error: (xhr) ->                  
        t.handleResponse(false, xhr.responseJSON)

) jQuery
