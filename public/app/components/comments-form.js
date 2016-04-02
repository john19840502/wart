(function() {

  define([], function() {
    var gen;
    gen = function(module) {
      'use strict';      return module.factory('CommentsForm', function() {
        return function($scope, $interval, method_get_page, method_get_new, method_post, mcan_post, mcan_view) {
          var startRefresh;
          $scope.comments = {
            data: [],
            newtext: "",
            loading: false,
            havemore: false,
            nextbase: 0,
            tcount: 0
          };
          $scope.allowPost = mcan_post;
          $scope.allowView = mcan_view;
          $scope.loadCommentsNew = function() {
            return method_get_new($scope.comments.tcount, function(responce) {
              $scope.comments.nextbase += responce.tcount - $scope.comments.tcount;
              $scope.comments.tcount = responce.tcount;
              $scope.comments.data.unshift.apply($scope.comments.data, responce.data);
              return $scope.$digest();
            });
          };
          startRefresh = function() {
            return $scope.comments.refresher = $interval($scope.loadCommentsNew, 10000);
          };
          $scope.loadComments = function(first) {
            if (first == null) first = false;
            $scope.comments.loading = true;
            return method_get_page($scope.comments.nextbase, function(responce) {
              $scope.comments.loading = false;
              $scope.comments.havemore = responce.havemore;
              $scope.comments.nextbase = responce.nextbase;
              $scope.comments.data.push.apply($scope.comments.data, responce.data);
              $scope.$digest();
              if (first) {
                $scope.comments.tcount = responce.tcount;
                return startRefresh();
              }
            });
          };
          $scope.addComment = function() {
            var text;
            if ($scope.comments.newtext.length > 3) {
              text = $scope.comments.newtext;
              $scope.comments.newtext = "";
              return method_post(text, function() {
                return $scope.loadCommentsNew();
              });
            } else {
              return alert("Введите текст комментария");
            }
          };
          if ($scope.allowView() != null) $scope.loadComments(true);
          return $scope.$on('$destroy', function() {
            if (angular.isDefined($scope.comments.refresher)) {
              return $interval.cancel($scope.comments.refresher);
            }
          });
        };
      });
    };
    return gen(angular.module('comments-form', []));
  });

}).call(this);
