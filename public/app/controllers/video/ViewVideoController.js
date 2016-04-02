(function() {
  'use strict';
  define(['app'], function(app) {
    return app.register.controller('ViewVideoController', [
      '$scope', '$log', '$routeParams', 'VideoStoreAPI', '$interval', 'CommentsForm', 'CurrentUserService', function($scope, $log, $routeParams, VideoStoreAPI, $interval, CommentsForm, CurrentUserService) {
        VideoStoreAPI.details($routeParams.id, function(video) {
          return $scope.video = video;
        });
        return CommentsForm($scope, $interval, function(nextbase, callback) {
          return VideoStoreAPI.videoCommentsList($routeParams.id, nextbase, callback);
        }, function(tcount, callback) {
          return VideoStoreAPI.videoCommentsListNew($routeParams.id, tcount, callback);
        }, function(text, callback) {
          return VideoStoreAPI.videoCommentPost($routeParams.id, text, callback);
        }, function() {
          return CurrentUserService.allow.PostVideoComment($routeParams.id);
        }, function() {
          return CurrentUserService.allow.ViewVideoComments($routeParams.id);
        });
      }
    ]);
  });

}).call(this);
