(function() {
  'use strict';
  define(['app'], function(app) {
    return app.register.controller('MyRequestsController', [
      '$scope', '$location', '$log', 'BrandStoreAPI', 'ListBaseController', function($scope, $location, $log, BrandStoreAPI, ListBaseController) {
        return ListBaseController($scope, $log, 'MyRequestsController', 'Мои игры (не подтвержденные)', 'app/views/partial/store/listitem_myrequests.html', BrandStoreAPI.itemListMyNeedApprove, function(item) {
          return $location.path("/Item/" + item.id);
        });
      }
    ]);
  });

}).call(this);
