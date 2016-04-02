'use strict';
define ['app'], (app)->
  app.register.controller 'MyAppsController', ['$scope', '$location', '$log', 'BrandStoreAPI', 'ListBaseController'
    ($scope, $location, $log, BrandStoreAPI, ListBaseController)->
      ListBaseController $scope, $log, 'MyAppsController', 'Мои игры (подтвержденные)','app/views/partial/store/listitem.html', BrandStoreAPI.itemListMyApproved,(item)->
        $location.path "/Item/#{item.id}"
  ]
