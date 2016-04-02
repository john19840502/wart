(function() {

  define(['service/wlad-ws'], function() {
    var gen;
    gen = function(module) {
      'use strict';      return module.factory('WladWSForm', [
        '$log', 'WladWS', function($log, WladWS) {
          var binary_add_tasks, formFilesToRequest, formToRequest, frequest_push_tasks, pushBinaryToRequest, _binary_tasks,
            _this = this;
          $log = $log.getInstance('WladWSForm');
          _binary_tasks = [];
          binary_add_tasks = function(tasks) {
            _.each(tasks, function(t) {
              _binary_tasks.push({
                id: t.id,
                file: t.file,
                onprogress: t.onprogress
              });
              delete t.file;
            });
          };
          pushBinaryToRequest = function(request, param_name, binary, onprogress) {
            if (request === null || binary === null) return;
            if (!request.hasOwnProperty('binary')) request.binary = [];
            request.binary.push({
              param_name: param_name,
              name: binary.name,
              size: binary.size,
              type: binary.type,
              id: WladWS.uniq(),
              file: binary,
              onprogress: onprogress
            });
            return request;
          };
          formToRequest = function(form) {
            var request;
            request = $(form).serializeJSON();
            if (form.action) request.action = form.action.match(/\#(.*)/)[1];
            return request;
          };
          formFilesToRequest = function(form, request, onprogress) {
            if (typeof onprogress !== "function") onprogress = null;
            $(form).find("input:file").each(function() {
              var file, _i, _len, _ref;
              _ref = this.files;
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                file = _ref[_i];
                pushBinaryToRequest(request, this.name, file, onprogress);
              }
            });
            return request;
          };
          frequest_push_tasks = function(request) {
            if (request.binary !== null) {
              binary_add_tasks(request.binary);
              _.each(request.binary, function(i) {
                delete i.onprogress;
              });
            }
            return request;
          };
          WladWS.setActor('Binary.Transmitter.getSlice', function(responce) {
            var b, bin, f, slcnt, slsize, _end, _start;
            if ((responce != null) && (responce.id != null) && (responce.snum != null)) {
              bin = _.findWhere(_binary_tasks, {
                id: responce.id
              });
              if (bin === null) {
                WladWS.sendRequest({
                  action: "BinaryTranspoder.ErrorRequestId",
                  id: responce.id
                }, null);
                return;
              }
              f = bin.file;
              if (f === null) {
                $log.debug('binary_transmitter_getSlice: file is null');
                return;
              }
              slsize = 1024 * 1024;
              slcnt = Math.ceil(f.size / slsize);
              if (slcnt <= responce.snum || responce.snum < 0) {
                WladWS.sendRequest({
                  action: "BinaryTranspoder.ErrorRequestSlice",
                  id: responce.id,
                  snum: responce.snum,
                  slices: slcnt
                }, null);
                return;
              }
              if (bin.onprogress != null) {
                bin.onprogress(responce.snum / slcnt, bin);
              }
              _start = responce.snum * slsize;
              _end = Math.min(_start + slsize, f.size);
              b = null;
              if (f.webkitSlice) {
                b = f.webkitSlice(_start, _end);
              } else if (f.mozSlice) {
                b = f.mozSlice(_start, _end);
              } else {
                b = f.slice(_start, _end);
              }
              return WladWS.sendBinary(b);
            }
          });
          WladWS.setActor('Binary.Transmitter.done', function(responce) {
            $log.debug('Binary.Transmitter.done: called ' + responce.id);
            _binary_tasks = _.reject(_binary_tasks, function(i) {
              if (i.id === responce.id) {
                if (i.onprogress != null) i.onprogress(1, i);
              }
              return true;
            });
            return false;
          });
          return {
            formToRequest: formToRequest,
            pushBinaryToRequest: pushBinaryToRequest,
            formFilesToRequest: formFilesToRequest,
            fullFormToRequest: function(form, onprogress) {
              return formFilesToRequest(form, formToRequest(form), onprogress);
            },
            sendFormRequest: function(request, callback) {
              return WladWS.sendRequest(frequest_push_tasks(request), callback);
            },
            SendFormRequestPromise: function(request) {
              return WladWS.sendRequestPromise(frequest_push_tasks(request));
            }
          };
        }
      ]);
    };
    return gen(angular.module('wlad-ws-form', ['wlad-ws']));
  });

}).call(this);
