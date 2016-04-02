'use strict';
define ['app'], (app)->
  app.register.controller 'AuthController', ['$scope', '$location', '$log', 'WladWS', '$timeout',
    ($scope, $location, $log, WladWS, $timeout)->
      WladWS.sendRequest {action: 'Auth.getAuthURI'}, (responce)->
        $scope.vk = responce.vk
        $scope.$digest()

      return
  ]
