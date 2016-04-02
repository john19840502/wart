(function() {
  'use strict';
  define(['app'], function(app) {
    return app.register.controller('CategoryController', [
      '$scope', '$location', '$routeParams', '$log', 'BrandStoreAPI', function($scope, $location, $routeParams, $log, BrandStoreAPI) {
        var i;
        $log = $log.getInstance('CategoryController');
        $scope.category_id = $routeParams.id;
        $scope.visible_tab = 0;
        $scope.loading = [true, true, true];
        $scope.havemore = [true, true, true];
        $scope.items = [[], [], []];
        $scope.nextbase = [-1, -1, -1];
        $scope.tabClass = function(tab) {
          if ($scope.visible_tab === tab) {
            return "active";
          } else {
            return "inactive";
          }
        };
        $scope.handtabClass = function(tab) {
          if ($scope.visible_tab === tab) {
            return "";
          } else {
            return "hand";
          }
        };
        $scope.tabClick = function(tab) {
          return $scope.visible_tab = tab;
        };
        $scope.isVisibleTab = function(tab) {
          return $scope.visible_tab === tab;
        };
        $scope.isLoading = function(tab) {
          return $scope.loading[tab];
        };
        $scope.haveMore = function(tab) {
          return !$scope.loading[tab] && $scope.havemore[tab];
        };
        $scope.load = function(tab) {
          var callback;
          callback = function(responce) {
            $scope.loading[tab] = false;
            $scope.havemore[tab] = responce.havemore;
            $scope.nextbase[tab] = responce.nextbase;
            $scope.items[tab].push.apply($scope.items[tab], responce.data);
            return $scope.$digest();
          };
          $scope.loading[tab] = true;
          switch (tab) {
            case 0:
              return BrandStoreAPI.categoryItemListPaid($scope.category_id, $scope.nextbase[tab], callback);
            case 1:
              return BrandStoreAPI.categoryItemListFree($scope.category_id, $scope.nextbase[tab], callback);
            case 2:
              return BrandStoreAPI.categoryItemListLoad($scope.category_id, $scope.nextbase[tab], callback);
          }
        };
        $scope.ItemClick = function(item) {
          $location.path("/Item/" + item.id);
          return $log.debug("ItemClick: " + item.id);
        };
        BrandStoreAPI.categoryDetails($scope.category_id, function(responce) {
          $scope.name = responce.name;
          return $scope.$digest();
        });
        for (i = 0; i <= 2; i++) {
          $scope.load(i);
        }
      }
    ]);
  });

}).call(this);
