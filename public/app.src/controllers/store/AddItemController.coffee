'use strict';
define ['app'], (app)->
  app.register.controller 'AddItemController', ['$scope', '$location', '$log', 'BrandStoreAPI','WladImage','$timeout'
    ($scope, $location, $log, BrandStoreAPI,WladImage,$timeout)->

      $log = $log.getInstance 'AddItemController'

      BrandStoreAPI.categoryList (responce)->
        $scope.categories = responce.data
        $scope.item.category = $scope.categories[0].id
        $scope.$digest()

      $scope.item = {
        name:''
        description:''
        category: -1
        cost:'0'
        picture512:''
        picture64:''
      }

      $scope.pictureChanged=($event)->
        WladImage.AsCropedDataURI $event.target.files[0] ,512,512,(c)->
          $scope.item.picture512=c
          $scope.$digest()

      $scope.submit = ()->
        if $scope.AddItemForm.$valid
          WladImage.URIScaletoURI $scope.item.picture512,64,(u64)->
            $scope.item.picture64=u64
            BrandStoreAPI.itemCreate $scope.item,(responce)->
              $timeout ()->
                $location.path "/Item/#{responce.new_id}"
        return
      return
  ]






