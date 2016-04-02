define [], ()->
  gen = (module)->
    'use strict';
    module.provider 'LoadingStateService', [()->
      rootScope = null
      EVENT_NAME = 'loading-state-changed'
      state = false
      usages = 0
      getState = ()->
        state
      setState = (_state)->
        if _state
          usages = usages + 1
        else
          usages = usages - 1
        if usages < 0
          usages = 0
        prev_state = state
        state = usages > 0
        if prev_state != state
          rootScope.$broadcast EVENT_NAME, {state}
        state
      @getState = getState
      @setState = setState
      @EVENT_NAME = EVENT_NAME

      @$get = ['$rootScope', ($rootScope)->
        rootScope = $rootScope
        @
      ]
      return
    ]
  gen angular.module 'loading-state-service', ['loading-state-service']


