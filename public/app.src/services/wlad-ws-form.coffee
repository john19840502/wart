define ['service/wlad-ws'], ()->
  gen = (module)->
    'use strict';
    module.factory 'WladWSForm',['$log', 'WladWS', ($log, WladWS)->
      $log = $log.getInstance 'WladWSForm'
      _binary_tasks = []
      binary_add_tasks = (tasks)->
        _.each tasks, (t)->
          _binary_tasks.push {id: t.id, file: t.file, onprogress: t.onprogress}
          delete t.file
          return
        return

      pushBinaryToRequest = (request, param_name, binary, onprogress)->
        if request == null || binary == null
          return
        if !request.hasOwnProperty 'binary'
          request.binary = []
        request.binary.push
          param_name: param_name
          name: binary.name
          size: binary.size
          type: binary.type
          id: WladWS.uniq()
          file: binary
          onprogress: onprogress
        request

      formToRequest = (form)->
        request = $(form).serializeJSON()
        if form.action
          request.action = form.action.match(/\#(.*)/)[1]
        request

      formFilesToRequest = (form, request, onprogress)->
        if typeof(onprogress) != "function"
          onprogress = null
        $(form).find("input:file").each ()->
          for file in @files
            pushBinaryToRequest request, @name, file, onprogress
          return
        request

      frequest_push_tasks = (request)->
        if request.binary != null
          binary_add_tasks request.binary
          _.each request.binary, (i)->
            delete i.onprogress
            return
        request


      WladWS.setActor 'Binary.Transmitter.getSlice', (responce)=>
        if responce? && responce.id? && responce.snum?
          bin = _.findWhere _binary_tasks, {id: responce.id}
          if bin == null
            WladWS.sendRequest {action: "BinaryTranspoder.ErrorRequestId", id: responce.id}, null
            return
          f = bin.file
          if f == null
            $log.debug 'binary_transmitter_getSlice: file is null'
            return
          slsize = 1024 * 1024
          slcnt = Math.ceil f.size / slsize
          if slcnt <= responce.snum || responce.snum < 0
            WladWS.sendRequest {action: "BinaryTranspoder.ErrorRequestSlice", id: responce.id, snum: responce.snum, slices: slcnt}, null
            return
          if bin.onprogress?
            bin.onprogress responce.snum / slcnt, bin
          _start = responce.snum * slsize;
          _end = Math.min _start + slsize, f.size
          b = null
          if f.webkitSlice
            b = f.webkitSlice _start, _end
          else if f.mozSlice
            b = f.mozSlice _start, _end
          else
            b = f.slice _start, _end
          WladWS.sendBinary b


      WladWS.setActor 'Binary.Transmitter.done', (responce)=>
        $log.debug 'Binary.Transmitter.done: called '+responce.id
        _binary_tasks = _.reject _binary_tasks, (i)->
          if i.id == responce.id
            if i.onprogress?
              i.onprogress 1, i
          true
        false


      { formToRequest,
      pushBinaryToRequest,
      formFilesToRequest,
      fullFormToRequest: (form, onprogress)->
        formFilesToRequest form, formToRequest(form), onprogress
      sendFormRequest: (request, callback)->
        WladWS.sendRequest frequest_push_tasks(request), callback
      SendFormRequestPromise: (request)->
        WladWS.sendRequestPromise frequest_push_tasks request
      }
    ]
  gen angular.module 'wlad-ws-form', ['wlad-ws']