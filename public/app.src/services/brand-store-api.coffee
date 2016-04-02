define ['service/wlad-ws', 'service/wlad-ws-form'], ()->
  gen = (module)->
    'use strict'
    module.factory 'BrandStoreAPI', ['$q', '$log', 'WladWS' , ($q, $log, WladWS, WladWSForm)->
      $log = $log.getInstance "BrandStoreAPI"

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


      categoryList = (callback)->
        WladWS.sendRequest { action: 'Category.list' }, callback

      categoryDetails = (category_id, callback)->
        WladWS.sendRequest IDRequest('Category.detail', category_id), callback


      list_item_prepare_data = (item)->
        if item?
          item.cost += 0
          item.cost = if item.cost == 0 then 'Бесплатно' else item.cost + 'p.'
          item.vote = '*' + item.vote
          item.picture = "/item_pic/l#{item.id}.png"
        item

      list_items_prepare_data = (items)->
        for item in items
          list_item_prepare_data item


      sendCatItemListRequest = (action, category_id, nextbase, callback)->
        WladWS.sendRequest ArgListRequest(action, category_id, nextbase), (responce)->
          responce.data = list_items_prepare_data responce.data
          callback responce

      categoryItemListFree = (category_id, nextbase, callback)->
        sendCatItemListRequest 'Item.list_by_cat_free', category_id, nextbase, callback

      categoryItemListLoad = (category_id, nextbase, callback)->
        sendCatItemListRequest 'Item.list_by_cat_load', category_id, nextbase, callback

      categoryItemListPaid = (category_id, nextbase, callback)->
        sendCatItemListRequest 'Item.list_by_cat_paid', category_id, nextbase, callback

      searchItemList = (filter, nextbase, callback)->
        sendCatItemListRequest 'Item.list_search', filter, nextbase, callback


      sendItemListRequest = (action, nextbase, callback)->
        WladWS.sendRequest ListRequest(action, nextbase), (responce)->
          responce.data = list_items_prepare_data responce.data
          callback responce

      itemListMyLoaded = (nextbase, callback)->
        sendItemListRequest 'Item.list_my_loads', nextbase, callback

      itemListMyApproved = (nextbase, callback)->
        sendItemListRequest 'Item.list_my_approve', nextbase, callback

      itemListMyNeedApprove = (nextbase, callback)->
        sendItemListRequest 'Item.list_my_needapprove', nextbase, callback

      itemListMyVotes = (nextbase, callback)->
        sendItemListRequest 'Item.list_my_votes', nextbase, callback

      itemListRequests = (nextbase, callback)->
        sendItemListRequest 'Item.list_requests', nextbase, callback


      item_view_prepare = (item)->
        item.votemax = item.vote1
        if item.votemax < item.vote2 then item.votemax = item.vote2
        if item.votemax < item.vote3 then item.votemax = item.vote3
        if item.votemax < item.vote4 then item.votemax = item.vote4
        if item.votemax < item.vote5 then item.votemax = item.vote5
        item.percent1 = (item.vote1 * 100 / item.votemax) | 0
        item.percent2 = (item.vote2 * 100 / item.votemax) | 0
        item.percent3 = (item.vote3 * 100 / item.votemax) | 0
        item.percent4 = (item.vote4 * 100 / item.votemax) | 0
        item.percent5 = (item.vote5 * 100 / item.votemax) | 0
        item.picture = "/item_pic/d#{item.id}.png"
        item

      itemDetails = (item_id, callback)->
        WladWS.sendRequest IDRequest('Item.details', item_id), (responce)->
          responce.data = item_view_prepare responce.data
          callback responce

      itemLoad = (item_id, callback)->
        WladWS.sendRequest IDRequest('Item.load', item_id), callback

      itemApprove = (item_id, callback)->
        WladWS.sendRequest IDRequest('Item.approve', item_id), callback

      itemVote = (item_id, score, callback)->
        request = IDRequest 'Item.vote', item_id
        request.val = score
        WladWS.sendRequest request, callback

      itemCreate = (item, callback)->
        WladWS.sendRequest {
          action: 'Item.add'
          name: item.name,
          description: item.description
          category: item.category
          cost: item.cost
          picture512: item.picture512
          picture64: item.picture64
        }, callback


      itemCommentPost = (item_id, text, callback)->
        request = IDRequest('Comment.post', item_id)
        request.text = text
        WladWS.sendRequest request, callback

      itemCommentsList = (item_id, nextbase, callback)->
        WladWS.sendRequest ArgListRequest('Comment.list_by_item', item_id, nextbase), callback

      itemCommentsListNew = (item_id, tcount, callback)->
        WladWS.sendRequest {action: 'Comment.list_by_item_new', arg: item_id, tcount}, callback


      {categoryList, categoryDetails, categoryItemListFree, categoryItemListLoad, categoryItemListPaid, itemListMyLoaded,
      itemListMyApproved, itemListMyNeedApprove, itemListMyVotes, itemListRequests, itemCommentsList, itemDetails,
      itemLoad, itemApprove, itemVote, list_item_prepare_data, list_items_prepare_data, item_view_prepare,
      itemCommentPost, itemCommentsListNew, searchItemList, itemCreate}

    ]
  gen angular.module 'brand-store-api', ['wlad-ws', 'wlad-ws-form']
