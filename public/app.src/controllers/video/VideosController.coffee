'use strict';
define ['app'], (app)->
  app.register.controller 'VideosController', ['$scope', '$location', '$log', 'VideoStoreAPI', 'ListBaseController'
    ($scope, $location, $log, VideoStoreAPI, ListBaseController)->
      ListBaseController $scope, $log, 'VideosController',
        'Список видео',
        'app/views/partial/video/listitem_video.html',
        VideoStoreAPI.videoListVideos, (item)->
          $location.path "/ViewVideo/#{item.id}"
  ]
