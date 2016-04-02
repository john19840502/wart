(function() {
  'use strict';
  define(['app'], function(app) {
    return app.register.controller('ItemController', [
      '$scope', '$log', '$routeParams', 'BrandStoreAPI', '$interval', 'CommentsForm', 'CurrentUserService', function($scope, $log, $routeParams, BrandStoreAPI, $interval, CommentsForm, CurrentUserService) {
        $log = $log.getInstance('ItemController');
        $scope.item = {};
        $scope.canIVote = function() {
          return $scope.item.myvote < 1 && CurrentUserService.allow.Vote();
        };
        $scope.canILoad = function() {
          return (!$scope.item.loaded) && CurrentUserService.allow.Load();
        };
        $scope.canIApprove = function() {
          return (!$scope.item.approved) && CurrentUserService.allow.Approve();
        };
        $scope.IwasVoted = function() {
          return $scope.item.myvote > 0;
        };
        $scope.Approve = function() {
          return BrandStoreAPI.itemApprove($routeParams.id, function(responce) {
            $scope.item.approved = responce.approved;
            return $scope.$digest();
          });
        };
        $scope.Load = function() {
          return BrandStoreAPI.itemLoad($routeParams.id, function(responce) {
            $scope.item.loaded = true;
            $scope.item.loads = responce.loads;
            return $scope.$digest();
          });
        };
        $scope.Vote = function(score) {
          return BrandStoreAPI.itemVote($routeParams.id, score, function(responce) {
            $scope.item.vote = responce.vote;
            $scope.item.myvote = score;
            return $scope.$digest();
          });
        };
        BrandStoreAPI.itemDetails($routeParams.id, function(resp) {
          $log.debug(resp);
          $scope.item = resp.data;
          return $scope.$digest();
        });
        return CommentsForm($scope, $interval, function(nextbase, callback) {
          return BrandStoreAPI.itemCommentsList($routeParams.id, nextbase, callback);
        }, function(tcount, callback) {
          return BrandStoreAPI.itemCommentsListNew($routeParams.id, tcount, callback);
        }, function(text, callback) {
          return BrandStoreAPI.itemCommentPost($routeParams.id, text, callback);
        }, function() {
          return CurrentUserService.allow.PostItemComment($routeParams.id);
        }, function() {
          return CurrentUserService.allow.ViewItemComments($routeParams.id);
        });
      }
    ]);
  });

}).call(this);
