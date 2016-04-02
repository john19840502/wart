'use strict';
define ['app'], (app)->
  app.register.controller 'CreateVideoController', ['$scope', '$location', '$log', 'VideoStoreAPI', '$timeout'
    ($scope, $location, $log, VideoStoreAPI, $timeout)->
      $log = $log.getInstance 'CreateVideoController'

      $scope.loading = false
      $scope.progress = 'подготовка...'
      $scope.loadstyle = {width: '100%'}
      $scope.item = {
        name: ''
        description: ''
      }

      $scope.fileChanged = (event)->
        $scope.item.file=event.target.files[0]

      $scope.submit = ()->
        $log.debug 'submit'
        $scope.loading = true
        VideoStoreAPI.videoCreate $scope.item.name, $scope.item.description, $scope.item.file, (progress)->
          $scope.progress = Math.round(progress * 100) + '%'
          $scope.loadstyle = {width: $scope.progress}
          $scope.$digest()
        ,(responce)->
          $timeout ()->
            $location.path "/ViewVideo/#{responce.new_id}"

      return
  ]