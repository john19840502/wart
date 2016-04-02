(function() {

  define(['service/wlad-ws'], function() {
    var gen;
    gen = function(module) {
      'use strict';      return module.provider('CurrentUserService', [
        function() {
          var AllowApprove, AllowLoad, AllowPostItem, AllowPostItemComment, AllowPostVideo, AllowPostVideoComment, AllowViewItemComments, AllowViewPrepVideos, AllowViewRequests, AllowViewSelfApproved, AllowViewSelfLoads, AllowViewSelfRequests, AllowViewSelfVideos, AllowViewSelfVotes, AllowViewVideoComments, AllowVote, IsAuthenticated, IsManager, debug_set_role, log, userData;
          log = null;
          userData = {
            id: -1,
            role: 0
          };
          debug_set_role = function(r) {
            return userData.role = r;
          };
          IsAuthenticated = function() {
            return userData.role > 0;
          };
          IsManager = function() {
            return userData.role > 1;
          };
          AllowVote = function() {
            return IsAuthenticated();
          };
          AllowLoad = function() {
            return IsAuthenticated();
          };
          AllowPostItem = function() {
            return IsAuthenticated();
          };
          AllowApprove = function() {
            return IsManager();
          };
          AllowPostItemComment = function(item_id) {
            return IsAuthenticated();
          };
          AllowViewItemComments = function(item_id) {
            return IsAuthenticated();
          };
          AllowViewSelfVotes = function() {
            return IsAuthenticated();
          };
          AllowViewSelfLoads = function() {
            return IsAuthenticated();
          };
          AllowViewSelfRequests = function() {
            return IsAuthenticated();
          };
          AllowViewSelfApproved = function() {
            return IsAuthenticated();
          };
          AllowViewRequests = function() {
            return IsManager();
          };
          AllowPostVideo = function() {
            return IsAuthenticated();
          };
          AllowPostVideoComment = function(video_id) {
            return IsAuthenticated();
          };
          AllowViewVideoComments = function(video_id) {
            return IsAuthenticated();
          };
          AllowViewSelfVideos = function() {
            return IsAuthenticated();
          };
          AllowViewPrepVideos = function() {
            return IsManager();
          };
          this.childs = {
            IsManager: IsManager,
            IsAuthenticated: IsAuthenticated,
            debug_set_role: debug_set_role,
            allow: {
              Vote: AllowVote,
              Load: AllowLoad,
              PostItem: AllowPostItem,
              Approve: AllowApprove,
              PostItemComment: AllowPostItemComment,
              ViewItemComments: AllowViewItemComments,
              ViewSelfVotes: AllowViewSelfVotes,
              ViewSelfLoads: AllowViewSelfLoads,
              ViewSelfRequests: AllowViewSelfRequests,
              ViewSelfApproved: AllowViewSelfApproved,
              ViewRequests: AllowViewRequests,
              PostVideo: AllowPostVideo,
              PostVideoComment: AllowPostVideoComment,
              ViewVideoComments: AllowViewVideoComments,
              ViewSelfVideos: AllowViewSelfVideos,
              ViewPrepVideos: AllowViewPrepVideos
            }
          };
          this.$get = [
            '$log', 'WladWS', function($log, WladWS) {
              log = $log.getInstance('CurrentUserService');
              return this.childs;
            }
          ];
        }
      ]);
    };
    return gen(angular.module('current-user-service', []));
  });

}).call(this);
