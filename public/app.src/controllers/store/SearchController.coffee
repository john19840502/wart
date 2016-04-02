'use strict';
define ['app'], (app)->
  app.register.controller 'SearchController', ['$scope', '$location', '$log', 'BrandStoreAPI', 'ListBaseController','$routeParams'
    ($scope, $location, $log, BrandStoreAPI, ListBaseController,$routeParams)->
      ListBaseController $scope, $log,
        'SearchController',
        "Рзультаты поиска: #{$routeParams.filter}",
        'app/views/partial/store/listitem.html',
        (nextbase,callback)->
          BrandStoreAPI.searchItemList $routeParams.filter,nextbase,callback
        ,(item)->
          $location.path "/Item/#{item.id}"
  ]
