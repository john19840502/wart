(function() {
  'use strict';
  define(['app'], function(app) {
    return app.register.controller('PrepVideoController', [
      '$scope', '$location', '$log', 'VideoStoreAPI', 'ListBaseController', function($scope, $location, $log, VideoStoreAPI, ListBaseController) {
        return ListBaseController($scope, $log, 'PrepVideoController', 'Видео на обработке', 'app/views/partial/video/listitem_video.html', VideoStoreAPI.videoListPrepVideo, function(item) {
          return $location.path("/ViewVideo/" + item.id);
        });
      }
    ]);
  });

}).call(this);
