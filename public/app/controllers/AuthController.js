(function() {
  'use strict';
  define(['app'], function(app) {
    return app.register.controller('AuthController', [
      '$scope', '$location', '$log', 'WladWS', '$timeout', function($scope, $location, $log, WladWS, $timeout) {
        WladWS.sendRequest({
          action: 'Auth.getAuthURI'
        }, function(responce) {
          $scope.vk = responce.vk;
          return $scope.$digest();
        });
      }
    ]);
  });

}).call(this);
