'use strict';
define ['app'], (app)->
  app.register.controller 'ViewVideoController', ['$scope', '$log', '$routeParams', 'VideoStoreAPI', '$interval',
                                                  'CommentsForm','CurrentUserService',
    ($scope, $log, $routeParams, VideoStoreAPI, $interval, CommentsForm,CurrentUserService)->
      VideoStoreAPI.details $routeParams.id, (video)->
        $scope.video = video

      CommentsForm $scope, $interval, (nextbase, callback)->
        VideoStoreAPI.videoCommentsList $routeParams.id, nextbase, callback
      , (tcount, callback)->
        VideoStoreAPI.videoCommentsListNew $routeParams.id, tcount, callback
      , (text, callback)->
        VideoStoreAPI.videoCommentPost $routeParams.id, text, callback
      ,()->
        CurrentUserService.allow.PostVideoComment($routeParams.id)
      ,()->
        CurrentUserService.allow.ViewVideoComments($routeParams.id)
  ]
