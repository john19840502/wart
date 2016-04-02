'use strict';
define ['app'], (app)->
  app.register.controller 'MyRequestsController', ['$scope', '$location', '$log', 'BrandStoreAPI', 'ListBaseController'
    ($scope, $location, $log, BrandStoreAPI, ListBaseController)->
      ListBaseController $scope, $log, 'MyRequestsController', 'Мои игры (не подтвержденные)','app/views/partial/store/listitem_myrequests.html', BrandStoreAPI.itemListMyNeedApprove,(item)->
        $location.path "/Item/#{item.id}"
  ]
