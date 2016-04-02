'use strict';
define ['app'], (app)->
  app.register.controller 'AuthCallBackController', ['$scope', '$routeParams','$log',
    ($scope, $routeParams, $log)->
      $scope.rp=$routeParams.params

      return
  ]
