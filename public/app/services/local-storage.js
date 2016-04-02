(function() {

  define([], function() {
    var gen;
    gen = function(module) {
      'use strict';      return module.factory('LocalStorage', [
        '$log', function($log) {
          var getItem, getItemRAW, onstorage, removeonstorage, setItem, setItemRAW;
          $log = $log.getInstance('LocalStorage');
          onstorage = function(cb) {
            if (typeof cb === "function") {
              if (window.addEventListener) {
                return window.addEventListener("storage", cb, false);
              } else {
                return window.attachEvent("onstorage", cb);
              }
            }
          };
          removeonstorage = function(cb) {
            if (typeof cb === "function") {
              if (window.removeEventListener) {
                return window.removeEventListener("storage", cb, false);
              } else {
                return window.detachEvent("onstorage", cb);
              }
            }
          };
          setItemRAW = function(key, value) {
            return localStorage.setItem(key, value);
          };
          getItemRAW = function(key) {
            return localStorage.getItem(key);
          };
          setItem = function(key, value) {
            return setItemRAW(key, JSON.stringify(value));
          };
          getItem = function(key) {
            return JSON.parce(getItemRAW(key));
          };
          return {
            setItemRAW: setItemRAW,
            getItemRAW: getItemRAW,
            onstorage: onstorage,
            setItem: setItem,
            getItem: getItem,
            removeonstorage: removeonstorage
          };
        }
      ]);
    };
    return gen(angular.module('local-storage', []));
  });

}).call(this);
