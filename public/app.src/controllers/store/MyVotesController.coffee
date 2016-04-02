'use strict';
define ['app'], (app)->
  app.register.controller 'MyVotesController', ['$scope', '$location', '$log', 'BrandStoreAPI', 'ListBaseController'
    ($scope, $location, $log, BrandStoreAPI, ListBaseController)->
      ListBaseController $scope, $log, 'MyVotesController', 'Мои оценки игр','app/views/partial/store/listitem_myvote.html', BrandStoreAPI.itemListMyVotes,(item)->
        $location.path "/Item/#{item.id}"
  ]
