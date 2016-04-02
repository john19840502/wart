define [], ()->
  gen = (module)->
    'use strict';
    module.factory 'ListBaseController', ()->
      ($scope, $log,controller_name,caption,item_template,load_method,on_item_click)->
        $log=$log.getInstance controller_name

        $scope.caption = caption
        $scope.loading = true
        $scope.havemore = true
        $scope.items = []
        $scope.nextbase = 0

        $scope.ListItemTemplate=()-> item_template

        $scope.isLoading = ()->
          $scope.loading

        $scope.haveMore = ()->
          !$scope.loading && $scope.havemore

        $scope.load = ()->
          $scope.loading = true
          load_method $scope.nextbase,(responce)->
            $scope.loading = false
            $scope.havemore = responce.havemore
            $scope.nextbase = responce.nextbase
            $scope.items.push.apply $scope.items,  responce.data
            $scope.$digest()

        $scope.ListItemClick = (item)->
          if on_item_click?
            on_item_click item

        $scope.load()

  gen angular.module 'list-base-controller', []