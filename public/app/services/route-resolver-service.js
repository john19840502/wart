(function() {

  define([], function() {
    var gen;
    gen = function(module) {
      'use strict';      return module.provider('routeResolver', [
        'LoadingStateServiceProvider', function(LoadingStateServiceProvider) {
          var controllersDirectory, getControllersDirectory, getViewsDirectory, resolve, resolveDependencies, routeConfig, setBaseDirectories, viewsDirectory;
          viewsDirectory = '/app/views/';
          controllersDirectory = '/app/controllers/';
          setBaseDirectories = function(viewsDir, controllersDir) {
            viewsDirectory = viewsDir;
            return controllersDirectory = controllersDir;
          };
          getViewsDirectory = function() {
            return viewsDirectory;
          };
          getControllersDirectory = function() {
            return controllersDirectory;
          };
          this.$get = function() {
            return this;
          };
          routeConfig = {
            setBaseDirectories: setBaseDirectories,
            getControllersDirectory: getControllersDirectory,
            getViewsDirectory: getViewsDirectory
          };
          this.routeConfig = routeConfig;
          resolveDependencies = function($q, $rootScope, dependencies) {
            var defer;
            defer = $q.defer();
            require(dependencies, function() {
              defer.resolve();
              $rootScope.$apply();
            });
            return defer.promise;
          };
          resolve = function(baseName, path, secure) {
            var routeDef;
            if (!path) path = '';
            routeDef = {};
            routeDef.templateUrl = "" + (routeConfig.getViewsDirectory()) + path + baseName + ".html";
            routeDef.controller = "" + baseName + "Controller";
            routeDef.secure = secure;
            routeDef.resolve = {
              load: [
                '$q', '$rootScope', function($q, $rootScope) {
                  return resolveDependencies($q, $rootScope, ["" + (routeConfig.getControllersDirectory()) + path + baseName + "Controller.js"]);
                }
              ]
            };
            return routeDef;
          };
          this.route = {
            resolve: resolve
          };
        }
      ]);
    };
    return gen(angular.module('route-resolver-service', []));
  });

}).call(this);
