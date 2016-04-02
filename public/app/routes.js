(function() {

  define(['app'], function(app) {
    'use strict';    return app.config([
      '$routeProvider', 'routeResolverProvider', function($routeProvider, routeResolverProvider) {
        var section, store, video;
        routeResolverProvider.routeConfig.setBaseDirectories('app/views/', 'app/controllers/');
        section = function(s) {
          return function(c, arg) {
            arg = arg != null ? "/:" + arg : '';
            return $routeProvider.when("/" + c + arg, routeResolverProvider.route.resolve(c, "" + s + "/"));
          };
        };
        $routeProvider.when("/Auth", routeResolverProvider.route.resolve('Auth'));
        store = section('store');
        store('MyLoads');
        store('MyApps');
        store('MyVotes');
        store('MyRequests');
        store('ManageRequests');
        store('CategoryList');
        store('Category', 'id');
        store('Item', 'id');
        store('AddItem');
        store('Search', 'filter');
        video = section('video');
        video('CreateVideo');
        video('Videos');
        video('PrepVideo');
        video('MyVideo');
        video('ViewVideo', 'id');
        return $routeProvider.otherwise({
          redirectTo: '/CategoryList'
        });
      }
    ]);
  });

}).call(this);
