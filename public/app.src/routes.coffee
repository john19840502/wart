define ['app'], (app)->
  'use strict'
  app.config ['$routeProvider', 'routeResolverProvider', ($routeProvider, routeResolverProvider)->
    routeResolverProvider.routeConfig.setBaseDirectories 'app/views/', 'app/controllers/'

    section = (s)->
      (c, arg)->
        arg = if arg? then "/:#{arg}" else ''
        $routeProvider.when "/#{c}#{arg}", routeResolverProvider.route.resolve(c, "#{s}/")


    $routeProvider.when "/Auth", routeResolverProvider.route.resolve('Auth')

    store = section 'store'
    store 'MyLoads'
    store 'MyApps'
    store 'MyVotes'
    store 'MyRequests'
    store 'ManageRequests'
    store 'CategoryList'
    store 'Category', 'id'
    store 'Item', 'id'
    store 'AddItem'
    store 'Search', 'filter'

    video = section 'video'
    video 'CreateVideo'
    video 'Videos'
    video 'PrepVideo'
    video 'MyVideo'
    video 'ViewVideo' , 'id'

    $routeProvider.otherwise { redirectTo: '/CategoryList' }

  ]
