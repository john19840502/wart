(function() {
  'use strict';
  define(['app'], function(app) {
    return app.register.controller('MyVotesController', [
      '$scope', '$location', '$log', 'BrandStoreAPI', 'ListBaseController', function($scope, $location, $log, BrandStoreAPI, ListBaseController) {
        return ListBaseController($scope, $log, 'MyVotesController', 'Мои оценки игр', 'app/views/partial/store/listitem_myvote.html', BrandStoreAPI.itemListMyVotes, function(item) {
          return $location.path("/Item/" + item.id);
        });
      }
    ]);
  });

}).call(this);
