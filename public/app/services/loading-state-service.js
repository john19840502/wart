(function() {

  define([], function() {
    var gen;
    gen = function(module) {
      'use strict';      return module.provider('LoadingStateService', [
        function() {
          var EVENT_NAME, getState, rootScope, setState, state, usages;
          rootScope = null;
          EVENT_NAME = 'loading-state-changed';
          state = false;
          usages = 0;
          getState = function() {
            return state;
          };
          setState = function(_state) {
            var prev_state;
            if (_state) {
              usages = usages + 1;
            } else {
              usages = usages - 1;
            }
            if (usages < 0) usages = 0;
            prev_state = state;
            state = usages > 0;
            if (prev_state !== state) {
              rootScope.$broadcast(EVENT_NAME, {
                state: state
              });
            }
            return state;
          };
          this.getState = getState;
          this.setState = setState;
          this.EVENT_NAME = EVENT_NAME;
          this.$get = [
            '$rootScope', function($rootScope) {
              rootScope = $rootScope;
              return this;
            }
          ];
        }
      ]);
    };
    return gen(angular.module('loading-state-service', ['loading-state-service']));
  });

}).call(this);
