(function() {

  define(['service/loading-state-service'], function() {
    var gen;
    gen = function(module) {
      'use strict';      return module.provider('BrandStoreRoutes', [
        'LoadingStateServiceProvider', function(LoadingStateServiceProvider) {
          var al, routes;
          al = LoadingStateServiceProvider.childs.allow;
          routes = s;
          this.routes = routes;
          this.$get = [
            function() {
              return this.routes;
            }
          ];
        }
      ]);
    };
    return gen(angular.module('wlad-ws', ['loading-state-service']));
  });

}).call(this);
