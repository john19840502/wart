define [], ()->
  gen = (module)->
    'use strict';
    module.factory 'CommentsForm', ()->
      ($scope, $interval, method_get_page, method_get_new, method_post,mcan_post,mcan_view)->
        $scope.comments = {
          data: []
          newtext: ""
          loading: false
          havemore: false
          nextbase: 0
          tcount: 0
        }

        $scope.allowPost = mcan_post
        $scope.allowView = mcan_view

        $scope.loadCommentsNew = ()->
          method_get_new $scope.comments.tcount, (responce)->
            $scope.comments.nextbase += responce.tcount - $scope.comments.tcount
            $scope.comments.tcount = responce.tcount
            $scope.comments.data.unshift.apply $scope.comments.data, responce.data
            $scope.$digest()

        startRefresh = ()->
          $scope.comments.refresher= $interval $scope.loadCommentsNew, 10000

        $scope.loadComments = (first = false)->
          $scope.comments.loading = true
          method_get_page $scope.comments.nextbase, (responce)->
            $scope.comments.loading = false
            $scope.comments.havemore = responce.havemore
            $scope.comments.nextbase = responce.nextbase
            $scope.comments.data.push.apply $scope.comments.data, responce.data
            $scope.$digest()
            if first
              $scope.comments.tcount = responce.tcount
              startRefresh()

        $scope.addComment = ()->
          if $scope.comments.newtext.length > 3
            text = $scope.comments.newtext
            $scope.comments.newtext = ""
            method_post text, ()->
              $scope.loadCommentsNew()
          else
            alert "Введите текст комментария"

        if $scope.allowView()?
          $scope.loadComments(true)

        $scope.$on '$destroy', ()->
          if angular.isDefined $scope.comments.refresher
            $interval.cancel $scope.comments.refresher

  gen angular.module 'comments-form', []
