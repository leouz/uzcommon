angular.module('ngStaticInclude', []).directive 'ngStaticInclude', ($http, $templateCache, $compile, $parse) ->
  (scope, element, attrs) ->
    loadTemplate = (templatePath) ->
      $http.get(templatePath, { cache: $templateCache }).success (response) ->
        element.html response
        $compile(element.contents()) scope
        
    templatePath = $parse(attrs.ngStaticInclude)(scope)
    
    attrs.$observe 'ngStaticInclude', (value) ->
      scope.$watch value, (templatePath) ->
        loadTemplate templatePath