(function() {
  var __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  define(['service/loading-state-service'], function() {
    var gen;
    gen = function(module) {
      'use strict';      return module.provider('WladWS', [
        function() {
          var fromJSON, toJSON, _SocketClass, _WebSocket, _protocols, _uri;
          _SocketClass = __indexOf.call(window, "MozWebSocket") >= 0 ? MozWebSocket : WebSocket;
          _uri = null;
          _protocols = null;
          _WebSocket = null;
          toJSON = JSON.stringify;
          fromJSON = JSON.parse;
          this.uri = function(uri, protocols) {
            protocols = Array.prototype.slice.call(arguments, 1);
            _uri = uri;
            _protocols = protocols;
            _WebSocket = new _SocketClass(uri, protocols);
            return this;
          };
          this.$get = [
            '$q', '$log', '$rootScope', 'LoadingStateService', function($q, $log, $rootScope, LoadingStateService) {
              var call_actor, call_handler, fsendInternal, fsendMessage, fsendRequest, fsendWaitedMeesages, uniq, wrappedWebSocket, ws, _actors, _handlers, _states, _wait_send;
              $log = $log.getInstance("Wlad-WS");
              ws = _WebSocket;
              _states = ['CONNECTING', 'OPEN', 'CLOSING', 'CLOSED'];
              _handlers = {};
              _actors = {};
              _wait_send = [];
              if (ws === null) throw "WladWS not configured with ::uri";
              uniq = function() {
                return new Date().getTime() + Math.random().toString(36).slice(2);
              };
              call_handler = function(name, message) {
                var handler;
                if (_handlers.hasOwnProperty(name)) {
                  handler = _handlers[name];
                  delete _handlers[name];
                  if (handler.callback !== null) {
                    handler.callback(message, handler.request);
                    return true;
                  }
                }
                return false;
              };
              call_actor = function(name, message) {
                var actor;
                if (_actors.hasOwnProperty(name)) {
                  actor = _actors[name];
                  if (actor != null) {
                    $rootScope.$apply(actor(message));
                    return true;
                  }
                }
                return false;
              };
              fsendWaitedMeesages = function() {
                var messages, msg, _i, _len;
                messages = _wait_send;
                _wait_send = [];
                for (_i = 0, _len = messages.length; _i < _len; _i++) {
                  msg = messages[_i];
                  $log.debug("Send waited: " + msg);
                  ws.send(msg);
                  LoadingStateService.setState(true);
                }
              };
              ws.onopen = function() {
                $log.info("WS Connection opened.");
                return fsendWaitedMeesages();
              };
              ws.onmessage = function(responce) {
                var responce_data;
                LoadingStateService.setState(false);
                try {
                  responce_data = fromJSON(responce.data);
                  if (!call_actor(responce_data.handler, responce_data)) {
                    call_handler(responce_data.handler, responce_data);
                  }
                  return $log.debug("Received: " + responce.data);
                } catch (e) {
                  return $log.error("Exception: " + e + " on handle message:" + responce.data);
                }
              };
              ws.onclose = function(close) {
                return $log.info("WS Connection closed: (" + close.code + ") " + close.reason);
              };
              ws.onerror = function(error) {
                return $log.error("Error: " + error.message);
              };
              fsendInternal = function(data) {
                switch (ws.readyState) {
                  case 0:
                    $log.debug("Put Send Wait: " + data);
                    _wait_send.push(data);
                    return true;
                  case 1:
                    $log.debug("Send: " + data);
                    LoadingStateService.setState(true);
                    ws.send(data);
                    return true;
                  default:
                    return false;
                }
              };
              fsendMessage = function(message) {
                return fsendInternal(toJSON(message));
              };
              fsendRequest = function(request, callback) {
                var cbRecord, handlerID;
                if (callback != null) {
                  handlerID = uniq();
                  cbRecord = {
                    request: request,
                    callback: callback
                  };
                  _handlers[handlerID] = cbRecord;
                  request.handler = handlerID;
                }
                if (!fsendMessage(request)) {
                  if (callback != null) delete _handlers[handlerID];
                  throw "Error sending via WS: Connection in " + _states[ws.readyState] + " state";
                }
              };
              wrappedWebSocket = {
                uniq: uniq,
                states: _states,
                close: function() {
                  ws.close();
                  return this;
                },
                readyState: function() {
                  return ws.readyState;
                },
                currentState: function() {
                  return this.states[ws.readyState];
                },
                sendBinary: function(binary) {
                  return fsendInternal(binary);
                },
                sendMessage: fsendMessage,
                sendRequest: fsendRequest,
                sendRequestPromise: function(request) {
                  var defer;
                  $log.debug('sendRequestPromise called');
                  defer = $q.defer();
                  fsendRequest(request, function(responce) {
                    return $rootScope.$apply(defer.resolve(responce.data));
                  });
                  return defer.promise;
                },
                setActor: function(name, callback) {
                  if (name === null || callback === null) return null;
                  return _actors[name] = callback;
                },
                RemoveActor: function(name) {
                  if (_actors.hasOwnProperty(name)) return delete _actors[name];
                },
                toJSON: toJSON,
                fromJSON: fromJSON
              };
              wrappedWebSocket.setActor('server_exception', function(responce) {
                return $log.error("server_exception " + (JSON.stringify(responce)));
              });
              return wrappedWebSocket;
            }
          ];
        }
      ]);
    };
    return gen(angular.module('wlad-ws', ['loading-state-service']));
  });

}).call(this);
