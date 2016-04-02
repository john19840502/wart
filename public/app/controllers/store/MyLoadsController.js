(function() {
  'use strict';
  define(['app'], function(app) {
    return app.register.controller('MyLoadsController', [
      '$scope', '$location', '$log', 'BrandStoreAPI', 'ListBaseController', function($scope, $location, $log, BrandStoreAPI, ListBaseController) {
        return ListBaseController($scope, $log, 'MyLoadsController', 'Мои игры (загруженные)', 'app/views/partial/store/listitem.html', BrandStoreAPI.itemListMyLoaded, function(item) {
          return $location.path("/Item/" + item.id);
        });
      }
    ]);
  });

}).call(this);
