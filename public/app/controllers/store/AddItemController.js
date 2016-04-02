(function() {
  'use strict';
  define(['app'], function(app) {
    return app.register.controller('AddItemController', [
      '$scope', '$location', '$log', 'BrandStoreAPI', 'WladImage', '$timeout', function($scope, $location, $log, BrandStoreAPI, WladImage, $timeout) {
        $log = $log.getInstance('AddItemController');
        BrandStoreAPI.categoryList(function(responce) {
          $scope.categories = responce.data;
          $scope.item.category = $scope.categories[0].id;
          return $scope.$digest();
        });
        $scope.item = {
          name: '',
          description: '',
          category: -1,
          cost: '0',
          picture512: '',
          picture64: ''
        };
        $scope.pictureChanged = function($event) {
          return WladImage.AsCropedDataURI($event.target.files[0], 512, 512, function(c) {
            $scope.item.picture512 = c;
            return $scope.$digest();
          });
        };
        $scope.submit = function() {
          if ($scope.AddItemForm.$valid) {
            WladImage.URIScaletoURI($scope.item.picture512, 64, function(u64) {
              $scope.item.picture64 = u64;
              return BrandStoreAPI.itemCreate($scope.item, function(responce) {
                return $timeout(function() {
                  return $location.path("/Item/" + responce.new_id);
                });
              });
            });
          }
        };
      }
    ]);
  });

}).call(this);
