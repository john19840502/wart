define ['angular'
        'service/loading-state-service'
        'service/wlad-ws'
        'service/wlad-ws-form'
        'service/wlad-image'
        'service/current-user-service'
        'service/brand-store-api'
        'service/video-store-api'
        'service/route-resolver-service'
        'component/list-base-controller'
        'component/comments-form'], ()->
  'use strict'
  app = angular.module 'app', ['ngRoute'
                               'loading-state-service'
                               'route-resolver-service'
                               'wlad-ws'
                               'wlad-ws-form'
                               'brand-store-api'
                               'video-store-api'
                               'current-user-service'
                               'wlad-image'
                               'list-base-controller'
                               'comments-form'
                               'angularFileUpload'
                               'ngAnimate'
                               'mindspace.logX']


  app.config ['$controllerProvider'
              '$compileProvider'
              '$filterProvider'
              '$provide'
              'WladWSProvider'
    ($controllerProvider, $compileProvider, $filterProvider, $provide, WladWSProvider)->
      app.register =
        controller: $controllerProvider.register
        directive: $compileProvider.directive
        filter: $filterProvider.register
        factory: $provide.factory
        service: $provide.service
      WladWSProvider.uri "ws://213.135.97.190:11777"
  ]
  app.controller 'MenuController', ['$scope', '$location','CurrentUserService',
    ($scope, $location,CurrentUserService)->
      menus = [
        'AddItem'
        'CategoryList'
        'ManageRequests'
        'MyApps'
        'MyLoads'
        'MyRequests'
        'MyVotes'
        'CreateVideo'
        'Videos'
        'PrepVideo'
        'MyVideo'
      ]
      set_m=(m)->
        $scope[m] = ()->
          $location.path "/#{m}"
      $scope.allow=CurrentUserService.allow

      $scope.Divider1=()-> $scope.allow.ViewSelfLoads() || $scope.allow.ViewSelfVotes()

      $scope.Divider2=()->
        if $scope.Divider1()?
          return  $scope.allow.ViewSelfApproved() || $scope.allow.ViewSelfRequests() || $scope.allow.PostItem()
        true

      $scope.Divider3=()->
        if $scope.Divider2()?
          return $scope.allow.ViewRequests()
        true

      $scope.setrole=(r)->
        CurrentUserService.debug_set_role(r)


      for m in menus
        set_m(m)
      return
  ]
  app.controller 'SearchFormController', ['$scope', '$location', '$log',
    ($scope, $location, $log )->
      $scope.filter=""
      $scope.submit =()->
        $location.path "/Search/#{$scope.filter}"
  ]
  app.controller 'LoadingPaneController',['$scope','LoadingStateService','$timeout',($scope,LoadingStateService,$timeout)->
    $scope.isLoading=LoadingStateService.getState
    $scope.$on LoadingStateService.EVENT_NAME,(event, args)->
      $timeout ()->
        $scope.$digest()
      return
  ]

  app.run ['$rootScope', '$location', ($rootScope, $location) ->
    $rootScope.$on '$routeChangeStart', (event)->
     #   if !Auth.isLoggedIn()
     #     console.log 'DENY'
     #   event.preventDefault()
     #   $location.path '/login'
     # else
     #   console.log('ALLOW')
     #   $location.path('/home')
  ]

  app


