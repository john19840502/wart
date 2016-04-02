define [], ()->
  gen = (module)->
    'use strict';
    module.factory 'LocalStorage', ['$log', ($log)->
      $log = $log.getInstance 'LocalStorage'

      onstorage = (cb)->
        if typeof(cb) == "function"
          if window.addEventListener
            window.addEventListener "storage", cb, false
          else
            window.attachEvent "onstorage", cb

      removeonstorage = (cb)->
        if typeof(cb) == "function"
          if window.removeEventListener
            window.removeEventListener "storage", cb, false
          else
            window.detachEvent "onstorage", cb

      setItemRAW = (key,value)->
        localStorage.setItem key, value

      getItemRAW = (key)->
        localStorage.getItem key

      setItem = (key,value)->
        setItemRAW key, JSON.stringify value

      getItem = (key)->
        JSON.parce getItemRAW key


      {setItemRAW,getItemRAW
      onstorage,setItem,getItem,
      removeonstorage
      }
    ]
  gen angular.module 'local-storage', []

