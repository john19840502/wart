define ['service/wlad-ws'], ()->
  gen = (module)->
    'use strict';
    module.provider 'CurrentUserService', [()->
      log = null

      userData = {
        id: -1,
        role: 0    #debug mode
      }

      debug_set_role = (r)->  #debug mode
        userData.role = r

      IsAuthenticated = ()->  #debug mode
        userData.role > 0

      IsManager = ()->  #debug mode
        userData.role > 1


      AllowVote = ()->
        IsAuthenticated()

      AllowLoad = ()->
        IsAuthenticated()

      AllowPostItem = ()->
        IsAuthenticated()

      AllowApprove = ()->
        IsManager()

      AllowPostItemComment = (item_id)->
        IsAuthenticated()

      AllowViewItemComments = (item_id)->
        IsAuthenticated()


      AllowViewSelfVotes = ()->
        IsAuthenticated()

      AllowViewSelfLoads = ()->
        IsAuthenticated()

      AllowViewSelfRequests = ()->
        IsAuthenticated()

      AllowViewSelfApproved = ()->
        IsAuthenticated()


      AllowViewRequests = ()->
        IsManager()


      AllowPostVideo = ()->
        IsAuthenticated()

      AllowPostVideoComment = (video_id)->
        IsAuthenticated()

      AllowViewVideoComments = (video_id)->
        IsAuthenticated()

      AllowViewSelfVideos = ()->
        IsAuthenticated()

      AllowViewPrepVideos = ()->
        IsManager()


      @childs =
        IsManager: IsManager
        IsAuthenticated: IsAuthenticated
        debug_set_role: debug_set_role     #debug mode
        allow:
          Vote: AllowVote
          Load: AllowLoad
          PostItem: AllowPostItem
          Approve: AllowApprove
          PostItemComment: AllowPostItemComment
          ViewItemComments: AllowViewItemComments
          ViewSelfVotes: AllowViewSelfVotes
          ViewSelfLoads: AllowViewSelfLoads
          ViewSelfRequests: AllowViewSelfRequests
          ViewSelfApproved: AllowViewSelfApproved
          ViewRequests: AllowViewRequests
          PostVideo: AllowPostVideo
          PostVideoComment: AllowPostVideoComment
          ViewVideoComments: AllowViewVideoComments
          ViewSelfVideos: AllowViewSelfVideos
          ViewPrepVideos: AllowViewPrepVideos

      @$get = ['$log', 'WladWS', ($log, WladWS)->
        log = $log.getInstance 'CurrentUserService'
        @childs
      ]
      return
    ]
  gen angular.module 'current-user-service', []

