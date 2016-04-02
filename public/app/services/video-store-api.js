(function() {

  define(['service/wlad-ws', 'service/wlad-ws-form'], function() {
    var gen;
    gen = function(module) {
      'use strict';      return module.factory('VideoStoreAPI', [
        '$q', '$log', 'WladWS', 'WladWSForm', function($q, $log, WladWS, WladWSForm) {
          var ArgListRequest, IDRequest, ListRequest, details, list_videos_prepare_data, sendVideoListRequest, videoCommentPost, videoCommentsList, videoCommentsListNew, videoCreate, videoListMyVideo, videoListPrepVideo, videoListVideos, video_prepare_data;
          $log = $log.getInstance("VideoStoreAPI");
          IDRequest = function(action, id) {
            return {
              action: action,
              id: id
            };
          };
          ListRequest = function(action, nextbase) {
            var request;
            request = {
              action: action
            };
            if (nextbase > 0) request.nextbase = nextbase;
            return request;
          };
          ArgListRequest = function(action, arg_id, nextbase) {
            var request;
            request = ListRequest(action, nextbase);
            request.arg = arg_id;
            return request;
          };
          video_prepare_data = function(item) {
            if (item != null) {
              item.lpicture = "/item_pic/l" + item.id + item.secret + ".png";
              item.dpicture = "/item_pic/d" + item.id + item.secret + ".png";
              item.media_flv = "/video/" + item.id + item.secret + ".flv";
              item.media_mp4 = "/video/" + item.id + item.secret + ".mp4";
              item.media_webm = "/video/" + item.id + item.secret + ".webm";
              item.media_ogv = "/video/" + item.id + item.secret + ".ogv";
            }
            return item;
          };
          list_videos_prepare_data = function(videos) {
            var video, _i, _len, _results;
            _results = [];
            for (_i = 0, _len = videos.length; _i < _len; _i++) {
              video = videos[_i];
              _results.push(video_prepare_data(video));
            }
            return _results;
          };
          sendVideoListRequest = function(action, nextbase, callback) {
            return WladWS.sendRequest(ListRequest(action, nextbase), function(responce) {
              responce.data = list_videos_prepare_data(responce.data);
              $log.info(JSON.stringify(responce));
              return callback(responce);
            });
          };
          videoListVideos = function(nextbase, callback) {
            return sendVideoListRequest('Video.list_video', nextbase, callback);
          };
          videoListPrepVideo = function(nextbase, callback) {
            return sendVideoListRequest('Video.list_prepvideo', nextbase, callback);
          };
          videoListMyVideo = function(nextbase, callback) {
            return sendVideoListRequest('Video.list_myvideo', nextbase, callback);
          };
          details = function(id, callback) {
            return WladWS.sendRequest(IDRequest('Video.details', id), function(responce) {
              return callback(video_prepare_data(responce.data));
            });
          };
          videoCommentPost = function(item_id, text, callback) {
            var request;
            request = IDRequest('CommentVideo.post', item_id);
            request.text = text;
            return WladWS.sendRequest(request, callback);
          };
          videoCommentsList = function(item_id, nextbase, callback) {
            return WladWS.sendRequest(ArgListRequest('CommentVideo.list_by_item', item_id, nextbase), callback);
          };
          videoCommentsListNew = function(item_id, tcount, callback) {
            return WladWS.sendRequest({
              action: 'CommentVideo.list_by_item_new',
              arg: item_id,
              tcount: tcount
            }, callback);
          };
          videoCreate = function(name, description, file, onprogress, callback) {
            var request;
            request = {
              action: 'Video.add',
              name: name,
              description: description
            };
            WladWSForm.pushBinaryToRequest(request, 'video', file, onprogress);
            return WladWSForm.sendFormRequest(request, callback);
          };
          return {
            videoListVideos: videoListVideos,
            videoListPrepVideo: videoListPrepVideo,
            videoListMyVideo: videoListMyVideo,
            details: details,
            videoCommentPost: videoCommentPost,
            videoCommentsList: videoCommentsList,
            videoCommentsListNew: videoCommentsListNew,
            videoCreate: videoCreate
          };
        }
      ]);
    };
    return gen(angular.module('video-store-api', ['wlad-ws', 'wlad-ws-form']));
  });

}).call(this);
