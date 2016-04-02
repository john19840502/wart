(function() {
  'use strict';
  define(['app'], function(app) {
    return app.register.controller('VideosController', [
      '$scope', '$location', '$log', 'VideoStoreAPI', 'ListBaseController', function($scope, $location, $log, VideoStoreAPI, ListBaseController) {
        return ListBaseController($scope, $log, 'VideosController', 'Список видео', 'app/views/partial/video/listitem_video.html', VideoStoreAPI.videoListVideos, function(item) {
          return $location.path("/ViewVideo/" + item.id);
        });
      }
    ]);
  });

}).call(this);
