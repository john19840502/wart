(function() {
  'use strict';
  define(['app'], function(app) {
    return app.register.controller('CreateVideoController', [
      '$scope', '$location', '$log', 'VideoStoreAPI', '$timeout', function($scope, $location, $log, VideoStoreAPI, $timeout) {
        $log = $log.getInstance('CreateVideoController');
        $scope.loading = false;
        $scope.progress = 'подготовка...';
        $scope.loadstyle = {
          width: '100%'
        };
        $scope.item = {
          name: '',
          description: ''
        };
        $scope.fileChanged = function(event) {
          return $scope.item.file = event.target.files[0];
        };
        $scope.submit = function() {
          $log.debug('submit');
          $scope.loading = true;
          return VideoStoreAPI.videoCreate($scope.item.name, $scope.item.description, $scope.item.file, function(progress) {
            $scope.progress = Math.round(progress * 100) + '%';
            $scope.loadstyle = {
              width: $scope.progress
            };
            return $scope.$digest();
          }, function(responce) {
            return $timeout(function() {
              return $location.path("/ViewVideo/" + responce.new_id);
            });
          });
        };
      }
    ]);
  });

}).call(this);
