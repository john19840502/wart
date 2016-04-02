(function() {
  'use strict';
  define(['app'], function(app) {
    return app.register.controller('MyAppsController', [
      '$scope', '$location', '$log', 'BrandStoreAPI', 'ListBaseController', function($scope, $location, $log, BrandStoreAPI, ListBaseController) {
        return ListBaseController($scope, $log, 'MyAppsController', 'Мои игры (подтвержденные)', 'app/views/partial/store/listitem.html', BrandStoreAPI.itemListMyApproved, function(item) {
          return $location.path("/Item/" + item.id);
        });
      }
    ]);
  });

}).call(this);
