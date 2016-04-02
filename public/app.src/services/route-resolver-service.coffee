define [], ()->
  gen = (module)->
    'use strict';
    module.provider 'routeResolver', ['LoadingStateServiceProvider', (LoadingStateServiceProvider)->
      viewsDirectory = '/app/views/'
      controllersDirectory = '/app/controllers/'

      setBaseDirectories = (viewsDir, controllersDir)->
        viewsDirectory = viewsDir
        controllersDirectory = controllersDir

      getViewsDirectory = ()->
        viewsDirectory

      getControllersDirectory = ()->
        controllersDirectory

      @$get = ()->
        @

      routeConfig = {
        setBaseDirectories
        getControllersDirectory
        getViewsDirectory
      }
      @routeConfig = routeConfig

      resolveDependencies = ($q, $rootScope, dependencies) ->
        defer = $q.defer()
        require dependencies, ()->
          defer.resolve()
          #LoadingStateServiceProvider.setState false
          $rootScope.$apply()
          return
        defer.promise

      resolve = (baseName, path, secure)->
        if !path
          path = ''
        routeDef = {}
        routeDef.templateUrl = "#{routeConfig.getViewsDirectory()}#{path}#{baseName}.html"
        routeDef.controller = "#{baseName}Controller"
        routeDef.secure=secure
        routeDef.resolve = {
          load: ['$q'
                 '$rootScope'
            ($q, $rootScope)->
              resolveDependencies $q, $rootScope, ["#{routeConfig.getControllersDirectory()}#{path}#{baseName}Controller.js"]
          ]
        }
        routeDef
      @route = {resolve}
      return
    ]
  gen angular.module 'route-resolver-service', []

