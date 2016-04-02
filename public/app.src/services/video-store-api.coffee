define ['service/wlad-ws', 'service/wlad-ws-form'], ()->
  gen = (module)->
    'use strict'
    module.factory 'VideoStoreAPI', ['$q', '$log', 'WladWS','WladWSForm' , ($q, $log, WladWS, WladWSForm)->
      $log = $log.getInstance "VideoStoreAPI"
      IDRequest = (action, id)->
        {action, id}

      ListRequest = (action, nextbase)->
        request = {action}
        if nextbase > 0
          request.nextbase = nextbase
        request

      ArgListRequest = (action, arg_id, nextbase)->
        request = ListRequest action, nextbase
        request.arg = arg_id
        request

        
      video_prepare_data = (item)->
        if item?
          item.lpicture = "/item_pic/l#{item.id}#{item.secret}.png"
          item.dpicture = "/item_pic/d#{item.id}#{item.secret}.png"
          item.media_flv = "/video/#{item.id}#{item.secret}.flv"
          item.media_mp4 = "/video/#{item.id}#{item.secret}.mp4"
          item.media_webm = "/video/#{item.id}#{item.secret}.webm"
          item.media_ogv = "/video/#{item.id}#{item.secret}.ogv"
        item

      list_videos_prepare_data = (videos)->
        for video in videos
          video_prepare_data video

      sendVideoListRequest = (action, nextbase, callback)->
        WladWS.sendRequest ListRequest(action, nextbase), (responce)->
          responce.data = list_videos_prepare_data responce.data
          $log.info JSON.stringify(responce)
          callback responce

      videoListVideos = (nextbase, callback)->
        sendVideoListRequest 'Video.list_video', nextbase, callback

      videoListPrepVideo = (nextbase, callback)->
        sendVideoListRequest 'Video.list_prepvideo', nextbase, callback

      videoListMyVideo = (nextbase, callback)->
        sendVideoListRequest 'Video.list_myvideo', nextbase, callback

      details = (id, callback)->
        WladWS.sendRequest IDRequest('Video.details', id), (responce)->
          callback video_prepare_data(responce.data)

      videoCommentPost = (item_id, text, callback)->
        request = IDRequest('CommentVideo.post', item_id)
        request.text = text
        WladWS.sendRequest request, callback

      videoCommentsList = (item_id, nextbase, callback)->
        WladWS.sendRequest ArgListRequest('CommentVideo.list_by_item', item_id, nextbase), callback

      videoCommentsListNew = (item_id, tcount, callback)->
        WladWS.sendRequest {action:'CommentVideo.list_by_item_new', arg:item_id, tcount}, callback

      videoCreate = (name,description,file,onprogress,callback)->
        request ={action:'Video.add',name,description}
        WladWSForm.pushBinaryToRequest request, 'video', file, onprogress
        WladWSForm.sendFormRequest request, callback

      {videoListVideos, videoListPrepVideo, videoListMyVideo, details, videoCommentPost, videoCommentsList, videoCommentsListNew,videoCreate}
    ]
  gen angular.module 'video-store-api', ['wlad-ws', 'wlad-ws-form']
