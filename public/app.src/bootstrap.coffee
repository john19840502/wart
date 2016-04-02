define ['require', 'lib/jquery','angular','lib/underscore/underscore-min'], (require)->
  'use strict';
  #require ['angular'],(require)->

  require ['lib/ng-file-upload/angular-file-upload',
           'angular-animate','angular-route', 'app', 'routes', 'domReady!', 'lib/bootstrap', 'mindspace.utils'], ()->
    angular.bootstrap(document, ['app'])
