(function() {

  define(['require', 'lib/jquery', 'angular', 'lib/underscore/underscore-min'], function(require) {
    'use strict';    return require(['lib/ng-file-upload/angular-file-upload', 'angular-animate', 'angular-route', 'app', 'routes', 'domReady!', 'lib/bootstrap', 'mindspace.utils'], function() {
      return angular.bootstrap(document, ['app']);
    });
  });

}).call(this);
