#TODO: move to a module
@app.provider 'routerBuilder', ($stateProvider, $urlRouterProvider) ->
  self = this
  
  self.buildState = (name, url, templateUrl, controller, modals) ->
    url += "/" if url[url.length - 1] isnt "/"

    $stateProvider.state { 
      name: name
      url: url
      templateUrl: templateUrl
      controller: controller
    }

    angular.forEach modals, (m) -> 
      m.url += "/" if m.url[m.url.length - 1] isnt "/"

      state = $stateProvider.state {
        name: "#{name}.#{m.name}"
        url: "#{m.url}"    
        controller: ($rootScope, $scope, $state, $stateParams, $modal) ->
          modalClose = (value) ->            
            $rootScope.$broadcast("$modalClose", { name: m.name, value: value })            
            $state.go $state.$current.parent.toString()
          
          modalDismiss = (value) ->
            $rootScope.$broadcast("$modalDismiss", { name: m.name, value: value })                      
            $state.go $state.$current.parent.toString()

          modalOpened = () ->            
            $rootScope.$broadcast("$modalOpened", { name: m.name })


          instance = $modal.open({ templateUrl: m.templateUrl, controller: m.controller })
          instance.opened.then(setTimeout(modalOpened, 500))
          instance.result.then(modalClose, modalDismiss)          
      }

  self.buildModalDef = (name, url, templateUrl, controller) ->
    {
      name: name
      url: url
      templateUrl: templateUrl
      controller: controller
    }

  {
    $get: () -> 'nothing'
    
    build: (builderFunc) ->    
      builderFunc({ state: self.buildState, modal: self.buildModalDef })

    addSlashAtEndOfUrls: () ->
      $urlRouterProvider.rule ($injector, $location) ->
        path = $location.path()
        search = $location.search()
        if path[path.length - 1] isnt "/"
          if search is {}
            path + "/"
          else
            params = []
            angular.forEach search, (v, k) ->
              params.push k + "=" + v
            path + "/?" + params.join("&")
  }
  
