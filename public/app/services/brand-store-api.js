(function() {

  define(['service/wlad-ws', 'service/wlad-ws-form'], function() {
    var gen;
    gen = function(module) {
      'use strict';      return module.factory('BrandStoreAPI', [
        '$q', '$log', 'WladWS', function($q, $log, WladWS, WladWSForm) {
          var ArgListRequest, IDRequest, ListRequest, categoryDetails, categoryItemListFree, categoryItemListLoad, categoryItemListPaid, categoryList, itemApprove, itemCommentPost, itemCommentsList, itemCommentsListNew, itemCreate, itemDetails, itemListMyApproved, itemListMyLoaded, itemListMyNeedApprove, itemListMyVotes, itemListRequests, itemLoad, itemVote, item_view_prepare, list_item_prepare_data, list_items_prepare_data, searchItemList, sendCatItemListRequest, sendItemListRequest;
          $log = $log.getInstance("BrandStoreAPI");
          IDRequest = function(action, id) {
            return {
              action: action,
              id: id
            };
          };
          ListRequest = function(action, nextbase) {
            var request;
            request = {
              action: action
            };
            if (nextbase > 0) request.nextbase = nextbase;
            return request;
          };
          ArgListRequest = function(action, arg_id, nextbase) {
            var request;
            request = ListRequest(action, nextbase);
            request.arg = arg_id;
            return request;
          };
          categoryList = function(callback) {
            return WladWS.sendRequest({
              action: 'Category.list'
            }, callback);
          };
          categoryDetails = function(category_id, callback) {
            return WladWS.sendRequest(IDRequest('Category.detail', category_id), callback);
          };
          list_item_prepare_data = function(item) {
            if (item != null) {
              item.cost += 0;
              item.cost = item.cost === 0 ? 'Бесплатно' : item.cost + 'p.';
              item.vote = '*' + item.vote;
              item.picture = "/item_pic/l" + item.id + ".png";
            }
            return item;
          };
          list_items_prepare_data = function(items) {
            var item, _i, _len, _results;
            _results = [];
            for (_i = 0, _len = items.length; _i < _len; _i++) {
              item = items[_i];
              _results.push(list_item_prepare_data(item));
            }
            return _results;
          };
          sendCatItemListRequest = function(action, category_id, nextbase, callback) {
            return WladWS.sendRequest(ArgListRequest(action, category_id, nextbase), function(responce) {
              responce.data = list_items_prepare_data(responce.data);
              return callback(responce);
            });
          };
          categoryItemListFree = function(category_id, nextbase, callback) {
            return sendCatItemListRequest('Item.list_by_cat_free', category_id, nextbase, callback);
          };
          categoryItemListLoad = function(category_id, nextbase, callback) {
            return sendCatItemListRequest('Item.list_by_cat_load', category_id, nextbase, callback);
          };
          categoryItemListPaid = function(category_id, nextbase, callback) {
            return sendCatItemListRequest('Item.list_by_cat_paid', category_id, nextbase, callback);
          };
          searchItemList = function(filter, nextbase, callback) {
            return sendCatItemListRequest('Item.list_search', filter, nextbase, callback);
          };
          sendItemListRequest = function(action, nextbase, callback) {
            return WladWS.sendRequest(ListRequest(action, nextbase), function(responce) {
              responce.data = list_items_prepare_data(responce.data);
              return callback(responce);
            });
          };
          itemListMyLoaded = function(nextbase, callback) {
            return sendItemListRequest('Item.list_my_loads', nextbase, callback);
          };
          itemListMyApproved = function(nextbase, callback) {
            return sendItemListRequest('Item.list_my_approve', nextbase, callback);
          };
          itemListMyNeedApprove = function(nextbase, callback) {
            return sendItemListRequest('Item.list_my_needapprove', nextbase, callback);
          };
          itemListMyVotes = function(nextbase, callback) {
            return sendItemListRequest('Item.list_my_votes', nextbase, callback);
          };
          itemListRequests = function(nextbase, callback) {
            return sendItemListRequest('Item.list_requests', nextbase, callback);
          };
          item_view_prepare = function(item) {
            item.votemax = item.vote1;
            if (item.votemax < item.vote2) item.votemax = item.vote2;
            if (item.votemax < item.vote3) item.votemax = item.vote3;
            if (item.votemax < item.vote4) item.votemax = item.vote4;
            if (item.votemax < item.vote5) item.votemax = item.vote5;
            item.percent1 = (item.vote1 * 100 / item.votemax) | 0;
            item.percent2 = (item.vote2 * 100 / item.votemax) | 0;
            item.percent3 = (item.vote3 * 100 / item.votemax) | 0;
            item.percent4 = (item.vote4 * 100 / item.votemax) | 0;
            item.percent5 = (item.vote5 * 100 / item.votemax) | 0;
            item.picture = "/item_pic/d" + item.id + ".png";
            return item;
          };
          itemDetails = function(item_id, callback) {
            return WladWS.sendRequest(IDRequest('Item.details', item_id), function(responce) {
              responce.data = item_view_prepare(responce.data);
              return callback(responce);
            });
          };
          itemLoad = function(item_id, callback) {
            return WladWS.sendRequest(IDRequest('Item.load', item_id), callback);
          };
          itemApprove = function(item_id, callback) {
            return WladWS.sendRequest(IDRequest('Item.approve', item_id), callback);
          };
          itemVote = function(item_id, score, callback) {
            var request;
            request = IDRequest('Item.vote', item_id);
            request.val = score;
            return WladWS.sendRequest(request, callback);
          };
          itemCreate = function(item, callback) {
            return WladWS.sendRequest({
              action: 'Item.add',
              name: item.name,
              description: item.description,
              category: item.category,
              cost: item.cost,
              picture512: item.picture512,
              picture64: item.picture64
            }, callback);
          };
          itemCommentPost = function(item_id, text, callback) {
            var request;
            request = IDRequest('Comment.post', item_id);
            request.text = text;
            return WladWS.sendRequest(request, callback);
          };
          itemCommentsList = function(item_id, nextbase, callback) {
            return WladWS.sendRequest(ArgListRequest('Comment.list_by_item', item_id, nextbase), callback);
          };
          itemCommentsListNew = function(item_id, tcount, callback) {
            return WladWS.sendRequest({
              action: 'Comment.list_by_item_new',
              arg: item_id,
              tcount: tcount
            }, callback);
          };
          return {
            categoryList: categoryList,
            categoryDetails: categoryDetails,
            categoryItemListFree: categoryItemListFree,
            categoryItemListLoad: categoryItemListLoad,
            categoryItemListPaid: categoryItemListPaid,
            itemListMyLoaded: itemListMyLoaded,
            itemListMyApproved: itemListMyApproved,
            itemListMyNeedApprove: itemListMyNeedApprove,
            itemListMyVotes: itemListMyVotes,
            itemListRequests: itemListRequests,
            itemCommentsList: itemCommentsList,
            itemDetails: itemDetails,
            itemLoad: itemLoad,
            itemApprove: itemApprove,
            itemVote: itemVote,
            list_item_prepare_data: list_item_prepare_data,
            list_items_prepare_data: list_items_prepare_data,
            item_view_prepare: item_view_prepare,
            itemCommentPost: itemCommentPost,
            itemCommentsListNew: itemCommentsListNew,
            searchItemList: searchItemList,
            itemCreate: itemCreate
          };
        }
      ]);
    };
    return gen(angular.module('brand-store-api', ['wlad-ws', 'wlad-ws-form']));
  });

}).call(this);
