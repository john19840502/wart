(function() {

  define([], function() {
    var gen;
    gen = function(module) {
      'use strict';      return module.factory('ListBaseController', function() {
        return function($scope, $log, controller_name, caption, item_template, load_method, on_item_click) {
          $log = $log.getInstance(controller_name);
          $scope.caption = caption;
          $scope.loading = true;
          $scope.havemore = true;
          $scope.items = [];
          $scope.nextbase = 0;
          $scope.ListItemTemplate = function() {
            return item_template;
          };
          $scope.isLoading = function() {
            return $scope.loading;
          };
          $scope.haveMore = function() {
            return !$scope.loading && $scope.havemore;
          };
          $scope.load = function() {
            $scope.loading = true;
            return load_method($scope.nextbase, function(responce) {
              $scope.loading = false;
              $scope.havemore = responce.havemore;
              $scope.nextbase = responce.nextbase;
              $scope.items.push.apply($scope.items, responce.data);
              return $scope.$digest();
            });
          };
          $scope.ListItemClick = function(item) {
            if (on_item_click != null) return on_item_click(item);
          };
          return $scope.load();
        };
      });
    };
    return gen(angular.module('list-base-controller', []));
  });

}).call(this);
