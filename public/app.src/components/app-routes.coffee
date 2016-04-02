define ['service/loading-state-service'], ()->
  gen = (module)->
    'use strict'
    module.provider 'BrandStoreRoutes',['LoadingStateServiceProvider',(LoadingStateServiceProvider)->

      al=LoadingStateServiceProvider.childs.allow

      routes=
        s

      @routes=routes
      @$get=[()->
        @routes
      ]
      return
    ]
  gen angular.module 'wlad-ws', ['loading-state-service']