window.mocks = () ->
  _m = @

  _m.results = []

  _m.addResult = (action) ->     
    _m.results.push(action)
  
  _m.expectations = []

  _m.expect = (action) -> _m.expectations.push(action)

  _m.assert = (action) ->    
    hasExpectation = (action) ->
      for e in _m.expectations
        return true if e == action
      return false

    hasResult = (action) ->
      for r in _m.results
        return true if r == action
      return false

    for r in _m.results
      throw new Error "Unexpected action: #{r} was found" if !hasExpectation(r)

    for e in _m.expectations
      throw new Error "Expected action: #{e} not found" if !hasResult(e)  

    true


  _m.array = (size) ->
    return [] if size == 0 
    size--
    result = []
    for i in [0..size]
      result.push({})    
    result
    
  _m.bootbox = () ->
    _t = _m.bootbox

    _t.alert = (message, callback) -> 
      _m.addResult('bootbox.alert')
      
      _t.clickOk = () ->      
        callback()

    _t.confirm = (message, callback) -> 
      _m.addResult('bootbox.confirm')

      _t.clickYes = () ->      
        callback(true)

      _t.clickNo = () ->      
        callback(false)

    _t

  _m.$modal = () ->
    _t = _m.$modal

    _t.open = (openData) ->
      _m.addResult('$modal.open')
      _t.openData = openData
      _t

    _t.result = {
      then: (confirmCallback, cancelCallback) ->
        _m.addResult('$modal.result.then')
        _t._confirmCallBack = confirmCallback
        _t._cancelCallback = cancelCallback  
    }

    _t.close = (item) ->    
      _t._confirmCallBack(item) if _t._confirmCallBack
    
    _t.dismiss = (type) ->    
      _t._cancelCallback(type) if _t._cancelCallback

    _t

  _m.$modalInstance = () ->
    _t = _m.$modalInstance

    _t.close = (item) ->    
      _m.addResult('$modalInstance.close')
      _t.closeItem = item
    
    _t.dismiss = (type) ->    
      _m.addResult('$modalInstance.dismiss')
      _t.dismissType = type

    _t

  _m