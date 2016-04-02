(function() {
  'use strict';
  define(['app'], function(app) {
    return app.register.controller('AuthCallBackController', [
      '$scope', '$routeParams', '$log', function($scope, $routeParams, $log) {
        $scope.rp = $routeParams.params;
      }
    ]);
  });

}).call(this);
