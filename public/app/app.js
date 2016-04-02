(function() {

  define(['angular', 'service/loading-state-service', 'service/wlad-ws', 'service/wlad-ws-form', 'service/wlad-image', 'service/current-user-service', 'service/brand-store-api', 'service/video-store-api', 'service/route-resolver-service', 'component/list-base-controller', 'component/comments-form'], function() {
    'use strict';
    var app;
    app = angular.module('app', ['ngRoute', 'loading-state-service', 'route-resolver-service', 'wlad-ws', 'wlad-ws-form', 'brand-store-api', 'video-store-api', 'current-user-service', 'wlad-image', 'list-base-controller', 'comments-form', 'angularFileUpload', 'ngAnimate', 'mindspace.logX']);
    app.config([
      '$controllerProvider', '$compileProvider', '$filterProvider', '$provide', 'WladWSProvider', function($controllerProvider, $compileProvider, $filterProvider, $provide, WladWSProvider) {
        app.register = {
          controller: $controllerProvider.register,
          directive: $compileProvider.directive,
          filter: $filterProvider.register,
          factory: $provide.factory,
          service: $provide.service
        };
        return WladWSProvider.uri("ws://213.135.97.190:11777");
      }
    ]);
    app.controller('MenuController', [
      '$scope', '$location', 'CurrentUserService', function($scope, $location, CurrentUserService) {
        var m, menus, set_m, _i, _len;
        menus = ['AddItem', 'CategoryList', 'ManageRequests', 'MyApps', 'MyLoads', 'MyRequests', 'MyVotes', 'CreateVideo', 'Videos', 'PrepVideo', 'MyVideo'];
        set_m = function(m) {
          return $scope[m] = function() {
            return $location.path("/" + m);
          };
        };
        $scope.allow = CurrentUserService.allow;
        $scope.Divider1 = function() {
          return $scope.allow.ViewSelfLoads() || $scope.allow.ViewSelfVotes();
        };
        $scope.Divider2 = function() {
          if ($scope.Divider1() != null) {
            return $scope.allow.ViewSelfApproved() || $scope.allow.ViewSelfRequests() || $scope.allow.PostItem();
          }
          return true;
        };
        $scope.Divider3 = function() {
          if ($scope.Divider2() != null) return $scope.allow.ViewRequests();
          return true;
        };
        $scope.setrole = function(r) {
          return CurrentUserService.debug_set_role(r);
        };
        for (_i = 0, _len = menus.length; _i < _len; _i++) {
          m = menus[_i];
          set_m(m);
        }
      }
    ]);
    app.controller('SearchFormController', [
      '$scope', '$location', '$log', function($scope, $location, $log) {
        $scope.filter = "";
        return $scope.submit = function() {
          return $location.path("/Search/" + $scope.filter);
        };
      }
    ]);
    app.controller('LoadingPaneController', [
      '$scope', 'LoadingStateService', '$timeout', function($scope, LoadingStateService, $timeout) {
        $scope.isLoading = LoadingStateService.getState;
        return $scope.$on(LoadingStateService.EVENT_NAME, function(event, args) {
          $timeout(function() {
            return $scope.$digest();
          });
        });
      }
    ]);
    app.run([
      '$rootScope', '$location', function($rootScope, $location) {
        return $rootScope.$on('$routeChangeStart', function(event) {});
      }
    ]);
    return app;
  });

}).call(this);
