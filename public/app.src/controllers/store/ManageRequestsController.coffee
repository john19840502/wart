'use strict';
define ['app'], (app)->
  app.register.controller 'ManageRequestsController', ['$scope', '$location', '$log', 'BrandStoreAPI', 'ListBaseController'
    ($scope, $location, $log, BrandStoreAPI, ListBaseController)->
      ListBaseController $scope, $log, 'ManageRequestsController', 'Запросы на подтверждение','app/views/partial/store/listitem_requests.html', BrandStoreAPI.itemListRequests,(item)->
        $location.path "/Item/#{item.id}"
  ]
