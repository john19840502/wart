'use strict';
define ['app'], (app)->
  app.register.controller 'MyVideoController', ['$scope', '$location', '$log', 'VideoStoreAPI', 'ListBaseController'
    ($scope, $location, $log, VideoStoreAPI, ListBaseController)->
      ListBaseController $scope, $log, 'MyVideoController',
        'Моё видео',
        'app/views/partial/video/listitem_video.html',
        VideoStoreAPI.videoListPrepVideo, (item)->
          $location.path "/ViewVideo/#{item.id}"
  ]
