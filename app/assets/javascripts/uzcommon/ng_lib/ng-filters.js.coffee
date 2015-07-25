@app.filter "noFractionCurrency", ($filter, locale) ->
  currencyFilter = $filter("currency")
  formats = $locale.NUMBER_FORMATS
  
  (amount, currencySymbol) ->
    value = currencyFilter(amount, currencySymbol)
    sep = value.indexOf(formats.DECIMAL_SEP)
    console.log amount, value
    return value.substring(0, sep) if amount >= 0
    return value.substring(0, sep) + ")"

@app.filter 'newlines', () ->
  (text) ->
    text.replace /\n/g, '<br/>'

@app.filter 'noHTML', ->
  (text) ->
    text.replace(/&/g, '&amp;').replace(/>/g, '&gt;').replace /</g, '&lt;'

@app.filter 'cut', ->
  (value, wordwise, max, tail) ->
    if !value
      return ''
    max = parseInt(max, 10)
    if !max
      return value
    if value.length <= max
      return value
    value = value.substr(0, max)
    if wordwise
      lastspace = value.lastIndexOf(' ')
      if lastspace != -1
        value = value.substr(0, lastspace)
    value + (tail or ' …')