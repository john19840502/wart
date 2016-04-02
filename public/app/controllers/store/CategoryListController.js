(function() {
  'use strict';
  define(['app'], function(app) {
    return app.register.controller('CategoryListController', [
      '$scope', '$location', '$log', 'BrandStoreAPI', function($scope, $location, $log, BrandStoreAPI) {
        $log = $log.getInstance('CategoryListController');
        $scope.categories = [];
        BrandStoreAPI.categoryList(function(responce) {
          $log.debug(responce);
          $scope.categories = responce.data;
          return $scope.$digest();
        });
        return $scope.CatalogClick = function(category) {
          $location.path("/Category/" + category.id);
          return $log.debug("CatalogClick: " + category.id);
        };
      }
    ]);
  });

}).call(this);
