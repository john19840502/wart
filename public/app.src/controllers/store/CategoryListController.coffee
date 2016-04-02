'use strict';
define ['app'],(app)->
  app.register.controller 'CategoryListController', ['$scope', '$location', '$log','BrandStoreAPI',
      ($scope, $location,$log,BrandStoreAPI)->

        $log=$log.getInstance 'CategoryListController'

#        $scope.categories = {}

        $scope.categories = []

        BrandStoreAPI.categoryList (responce)->
          $log.debug(responce)
          $scope.categories = responce.data
          $scope.$digest()

        $scope.CatalogClick = (category)->
          $location.path "/Category/#{category.id}"
          $log.debug "CatalogClick: #{category.id}"
      ]
