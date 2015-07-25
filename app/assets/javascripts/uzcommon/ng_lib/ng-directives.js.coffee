@app.directive 'ngCssBgImg', ->
  (scope, element, attrs) ->
    url = attrs.ngCssBgImg    
    element.css
      'background-image': 'url(' + url + ')'
      'background-size': 'cover'

@app.directive 'loading', ($http) ->
  {
    restrict: 'A'
    link: (scope, elm, attrs) ->

      scope.isLoading = ->
        $http.pendingRequests.length > 0

      scope.$watch scope.isLoading, (v) ->
        if v
          elm.show()
        else
          elm.hide()      
  }