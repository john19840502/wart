(function() {
  'use strict';
  define(['app'], function(app) {
    return app.register.controller('ManageRequestsController', [
      '$scope', '$location', '$log', 'BrandStoreAPI', 'ListBaseController', function($scope, $location, $log, BrandStoreAPI, ListBaseController) {
        return ListBaseController($scope, $log, 'ManageRequestsController', 'Запросы на подтверждение', 'app/views/partial/store/listitem_requests.html', BrandStoreAPI.itemListRequests, function(item) {
          return $location.path("/Item/" + item.id);
        });
      }
    ]);
  });

}).call(this);
