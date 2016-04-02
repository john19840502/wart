define ['service/loading-state-service'], ()->
  gen = (module)->
    'use strict'
    module.provider 'WladWS',[()->
      _SocketClass = if "MozWebSocket" in window then MozWebSocket else WebSocket
      _uri = null
      _protocols = null
      _WebSocket = null
      toJSON = JSON.stringify
      fromJSON = JSON.parse

      @uri = (uri, protocols)->
        protocols = Array.prototype.slice.call arguments, 1
        _uri = uri
        _protocols = protocols
        _WebSocket = new _SocketClass uri, protocols
        @

      @$get = ['$q', '$log', '$rootScope','LoadingStateService' , ($q, $log, $rootScope,LoadingStateService)->
        $log = $log.getInstance "Wlad-WS"
        ws = _WebSocket
        _states = ['CONNECTING', 'OPEN', 'CLOSING', 'CLOSED']
        _handlers = {}
        _actors = {}
        _wait_send = []

        if ws == null
          throw "WladWS not configured with ::uri"

        uniq = ()->
          (new Date().getTime() + Math.random().toString(36).slice(2))

        call_handler = (name, message)->
          if _handlers.hasOwnProperty name
            handler = _handlers[name]
            delete _handlers[name]
            if handler.callback != null
              handler.callback message, handler.request
              return true
          false

        call_actor = (name, message)->
          if _actors.hasOwnProperty name
            actor = _actors[name]
            if actor?
              $rootScope.$apply actor message
              return true
          false

        fsendWaitedMeesages = ()->
          messages = _wait_send
          _wait_send = []
          for msg in messages
            $log.debug "Send waited: #{msg}"
            ws.send msg
            LoadingStateService.setState true
          return

        ws.onopen = ()->
          $log.info "WS Connection opened."
          fsendWaitedMeesages()

        ws.onmessage = (responce)->
          LoadingStateService.setState false
          try
            responce_data = fromJSON responce.data
            if !call_actor responce_data.handler, responce_data
              call_handler responce_data.handler, responce_data
            $log.debug "Received: #{responce.data}"
          catch e
            $log.error "Exception: #{e} on handle message:#{responce.data}"


        ws.onclose = (close)->
          $log.info "WS Connection closed: (#{close.code}) #{close.reason}"

        ws.onerror = (error)->
          $log.error "Error: #{error.message}"

        fsendInternal = (data)->
          switch ws.readyState
            when 0
              $log.debug "Put Send Wait: #{data}"
              _wait_send.push data
              true
            when 1
              $log.debug "Send: #{data}"
              LoadingStateService.setState true
              ws.send data
              true
            else
              false

        fsendMessage = (message)->
          fsendInternal toJSON message

        fsendRequest = (request, callback)->
          if callback?
            handlerID = uniq()
            cbRecord = {request, callback}
            _handlers[handlerID] = cbRecord
            request.handler = handlerID
          if !fsendMessage request
            if callback?
              delete _handlers[handlerID]
            throw "Error sending via WS: Connection in #{_states[ws.readyState]} state"

        wrappedWebSocket =
          uniq: uniq
          states: _states
          close: ()->
            ws.close()
            @
          readyState: ()->
            ws.readyState
          currentState: ()->
            @states[ws.readyState]
          sendBinary: (binary)->
            fsendInternal binary
          sendMessage: fsendMessage
          sendRequest: fsendRequest
          sendRequestPromise: (request)->
            $log.debug 'sendRequestPromise called'
            defer = $q.defer()
            fsendRequest request, (responce)->
              $rootScope.$apply defer.resolve responce.data
            defer.promise

          setActor: (name, callback)->
            if name == null || callback == null
              return null
            _actors[name] = callback

          RemoveActor: (name)->
            if _actors.hasOwnProperty(name)
              delete _actors[name]

          toJSON: toJSON
          fromJSON: fromJSON


        wrappedWebSocket.setActor 'server_exception', (responce)->
          $log.error "server_exception #{JSON.stringify responce}"

        wrappedWebSocket
      ]
      return
    ]
  gen angular.module 'wlad-ws', ['loading-state-service']