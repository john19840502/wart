'use strict';
define ['app'], (app)->
  app.register.controller 'PrepVideoController', ['$scope', '$location', '$log', 'VideoStoreAPI', 'ListBaseController'
    ($scope, $location, $log, VideoStoreAPI, ListBaseController)->
      ListBaseController $scope, $log, 'PrepVideoController',
        'Видео на обработке',
        'app/views/partial/video/listitem_video.html',
        VideoStoreAPI.videoListPrepVideo, (item)->
          $location.path "/ViewVideo/#{item.id}"
  ]
