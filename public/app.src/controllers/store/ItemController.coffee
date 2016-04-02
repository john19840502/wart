'use strict';
define ['app'], (app)->
  app.register.controller 'ItemController', ['$scope', '$log', '$routeParams', 'BrandStoreAPI', '$interval','CommentsForm','CurrentUserService',
    ($scope, $log, $routeParams, BrandStoreAPI, $interval, CommentsForm,CurrentUserService)->
      $log = $log.getInstance 'ItemController'

      $scope.item = {}


      $scope.canIVote = ()->
        $scope.item.myvote < 1 && CurrentUserService.allow.Vote()

      $scope.canILoad = ()->
        (!$scope.item.loaded) && CurrentUserService.allow.Load()

      $scope.canIApprove = ()->
        (!$scope.item.approved) && CurrentUserService.allow.Approve()

      $scope.IwasVoted = ()->
        $scope.item.myvote > 0

      $scope.Approve = ()->
        BrandStoreAPI.itemApprove $routeParams.id, (responce)->
          $scope.item.approved = responce.approved
          $scope.$digest()

      $scope.Load = ()->
        BrandStoreAPI.itemLoad $routeParams.id, (responce)->
          $scope.item.loaded = true
          $scope.item.loads = responce.loads
          $scope.$digest()

      $scope.Vote = (score)->
        BrandStoreAPI.itemVote $routeParams.id, score, (responce)->
          $scope.item.vote = responce.vote
          $scope.item.myvote = score
          $scope.$digest()

      BrandStoreAPI.itemDetails $routeParams.id, (resp)->
        $log.debug(resp)
        $scope.item = resp.data
        $scope.$digest()

      CommentsForm $scope, $interval, (nextbase, callback)->
        BrandStoreAPI.itemCommentsList    $routeParams.id, nextbase, callback
      ,(tcount, callback)->
        BrandStoreAPI.itemCommentsListNew $routeParams.id, tcount, callback
      ,(text, callback)->
        BrandStoreAPI.itemCommentPost     $routeParams.id, text, callback
      ,()->
        CurrentUserService.allow.PostItemComment($routeParams.id)
      ,()->
        CurrentUserService.allow.ViewItemComments($routeParams.id)

  ]
