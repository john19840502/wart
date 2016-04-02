'use strict';
define ['app'], (app)->
  app.register.controller 'MyLoadsController', ['$scope', '$location', '$log', 'BrandStoreAPI', 'ListBaseController'
    ($scope, $location, $log, BrandStoreAPI, ListBaseController)->
      ListBaseController $scope, $log, 'MyLoadsController',
        'Мои игры (загруженные)',
        'app/views/partial/store/listitem.html',
        BrandStoreAPI.itemListMyLoaded,(item)->
          $location.path "/Item/#{item.id}"
  ]
