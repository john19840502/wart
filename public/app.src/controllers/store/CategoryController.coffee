'use strict';
define ['app'], (app)->
  app.register.controller 'CategoryController', ['$scope', '$location', '$routeParams', '$log', 'BrandStoreAPI',
    ($scope, $location, $routeParams, $log, BrandStoreAPI)->
      $log = $log.getInstance 'CategoryController'

      $scope.category_id = $routeParams.id
      $scope.visible_tab = 0
#      $scope.name = ""
      $scope.loading = [true, true, true]
      $scope.havemore = [true, true, true]
      $scope.items = [[], [], []]
      $scope.nextbase = [-1, -1, -1]


      $scope.tabClass = (tab)->
        if $scope.visible_tab == tab then "active" else "inactive"


      $scope.handtabClass = (tab)->
        if $scope.visible_tab == tab then "" else "hand"


      $scope.tabClick = (tab)->
        $scope.visible_tab = tab


      $scope.isVisibleTab = (tab)->
        $scope.visible_tab == tab


      $scope.isLoading = (tab)->
        $scope.loading[tab]


      $scope.haveMore = (tab)->
        !$scope.loading[tab] && $scope.havemore[tab]

      $scope.load = (tab)->
        callback = (responce)->
          $scope.loading[tab] = false
          $scope.havemore[tab] = responce.havemore
          $scope.nextbase[tab] = responce.nextbase
          $scope.items[tab].push.apply $scope.items[tab],  responce.data
          $scope.$digest()
        $scope.loading[tab] = true
        switch tab
          when 0
            BrandStoreAPI.categoryItemListPaid $scope.category_id, $scope.nextbase[tab], callback
          when 1
            BrandStoreAPI.categoryItemListFree $scope.category_id, $scope.nextbase[tab], callback
          when 2
            BrandStoreAPI.categoryItemListLoad $scope.category_id, $scope.nextbase[tab], callback

      $scope.ItemClick = (item)->
        $location.path "/Item/#{item.id}"
        $log.debug "ItemClick: #{item.id}"

      BrandStoreAPI.categoryDetails $scope.category_id, (responce)->
        $scope.name = responce.name
        $scope.$digest()

      for i in [0..2]
        $scope.load i
      return
  ]
