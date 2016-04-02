(function() {
  'use strict';
  define(['app'], function(app) {
    return app.register.controller('SearchController', [
      '$scope', '$location', '$log', 'BrandStoreAPI', 'ListBaseController', '$routeParams', function($scope, $location, $log, BrandStoreAPI, ListBaseController, $routeParams) {
        return ListBaseController($scope, $log, 'SearchController', "Рзультаты поиска: " + $routeParams.filter, 'app/views/partial/store/listitem.html', function(nextbase, callback) {
          return BrandStoreAPI.searchItemList($routeParams.filter, nextbase, callback);
        }, function(item) {
          return $location.path("/Item/" + item.id);
        });
      }
    ]);
  });

}).call(this);
