$ ->
  $.mobileCheck = (version, minWidth) ->
    window.mobileCheck = { 
      minWidth: minWidth
      version: version
    }

    check = ->
      isResolutionTooSmall = () -> $(window).width() < window.mobileCheck.minWidth
    
      cleanUrl = () ->
        cleanUrl = window.location.pathname.replace("?mobile").replace("=0").replace("=1")  
        if cleanUrl.substr(cleanUrl.length - 1) == '/'
          cleanUrl = cleanUrl.substr(0, cleanUrl.length - 1)
        cleanUrl

      if window.mobileCheck.version == 'desktop' and (isResolutionTooSmall())
        $('body').hide(500)      
        window.location = cleanUrl() + '/?mobile=1'
      
      else if (window.mobileCheck.version == 'mobile' and !(isResolutionTooSmall())) or window.location.pathname.indexOf('/admin') == 0
        $('body').hide(500)
        window.location = cleanUrl() + '/?mobile=0'

    $(window).resize ->
      check()
    
    check()