(function() {

  define([], function() {
    var gen;
    gen = function(module) {
      'use strict';      return module.factory('WladImage', function() {
        var AsCropedDataURI, CropImage, CropImageCanvas, CropImageToAspect, CropImageToAspectCanvas, CropedCanvas, HalfScaleCanvas, ImageDownScale, ImageDownScaleAsCanvas, ImageTransform, ImagedCanvas, ReadFileURI, URIImageLoad, URIScaletoURI, fileToImage, getCropAspectParams;
        ReadFileURI = function(file, func) {
          var reader;
          reader = new FileReader();
          reader.onload = function() {
            return func(reader.result);
          };
          reader.readAsDataURL(file);
          return reader;
        };
        URIImageLoad = function(uri, func) {
          var tempImg;
          tempImg = new Image();
          tempImg.onload = function() {
            return func(this);
          };
          tempImg.src = uri;
          return tempImg;
        };
        fileToImage = function(file, func) {
          return ReadFileURI(file, function(uri) {
            return URIImageLoad(uri, func);
          });
        };
        CropImageCanvas = function(img, x, y, w, h, onready) {
          var canvas, ctx;
          canvas = document.createElement('canvas');
          canvas.width = w;
          canvas.height = h;
          ctx = canvas.getContext("2d");
          ctx.drawImage(img, x, y, w, h, 0, 0, w, h);
          return onready(canvas);
        };
        CropImage = function(img, x, y, w, h, onready) {
          return CropImageCanvas(img, x, y, w, h, function(cc) {
            return URIImageLoad(cc.toDataURL('image/png'), onready);
          });
        };
        getCropAspectParams = function(img, a) {
          var h, ia, w, x, y;
          ia = img.width / img.height;
          if (ia > a) {
            w = Math.round(img.height * a);
            x = Math.round((img.width - w) / 2.0);
            y = 0;
            h = img.height;
          } else {
            h = Math.round(img.width * a);
            y = Math.round((img.height - h) / 2.0);
            x = 0;
            w = img.width;
          }
          return {
            x: x,
            y: y,
            w: w,
            h: h
          };
        };
        CropImageToAspectCanvas = function(img, a, onready) {
          var p;
          p = getCropAspectParams(img, a);
          return CropImageCanvas(img, p.x, p.y, p.w, p.h, onready);
        };
        CropImageToAspect = function(img, a, onready) {
          var p;
          p = getCropAspectParams(img, a);
          return CropImage(img, p.x, p.y, p.w, p.h, onready);
        };
        ImagedCanvas = function(canvas, img, w, h, func) {
          var ctx;
          if (!(canvas != null)) canvas = document.createElement('canvas');
          canvas.width = w;
          canvas.height = h;
          ctx = canvas.getContext("2d");
          ctx.drawImage(img, 0, 0, img.width, img.height, 0, 0, w, h);
          return func(canvas);
        };
        ImageTransform = function(img, w, h, func) {
          return ImagedCanvas(null, img, w, h, function(c) {
            return URIImageLoad(c.toDataURL('image/png'), func);
          });
        };
        HalfScaleCanvas = function(c) {
          var hc;
          hc = document.createElement('canvas');
          hc.width = c.width / 2;
          hc.height = c.height / 2;
          hc.getContext('2d').drawImage(c, 0, 0, hc.width, hc.height);
          return hc;
        };
        ImageDownScaleAsCanvas = function(tx, img, func) {
          var a;
          while (img.width > tx * 2) {
            img = HalfScaleCanvas(img);
          }
          a = img.height / img.width;
          return ImagedCanvas(null, img, tx, Math.round(tx * a), func);
        };
        ImageDownScale = function(tx, img, func) {
          return ImageDownScaleAsCanvas(tx, img, function(c) {
            return URIImageLoad(c.toDataURL('image/png'), func);
          });
        };
        URIScaletoURI = function(uri, sx, func) {
          return URIImageLoad(uri, function(img) {
            return ImageDownScaleAsCanvas(sx, img, function(c) {
              return func(c.toDataURL('image/png'));
            });
          });
        };
        CropedCanvas = function(file, sx, sy, onready) {
          return fileToImage(file, function(img) {
            return CropImageToAspect(img, sx / sy, function(_img) {
              return ImageDownScaleAsCanvas(sx, _img, onready);
            });
          });
        };
        AsCropedDataURI = function(file, sx, sy, onready) {
          return CropedCanvas(file, sx, sy, function(c) {
            return onready(c.toDataURL('image/png'));
          });
        };
        return {
          ReadFileURI: ReadFileURI,
          URIImageLoad: URIImageLoad,
          fileToImage: fileToImage,
          CropImageCanvas: CropImageCanvas,
          CropImage: CropImage,
          getCropAspectParams: getCropAspectParams,
          CropImageToAspectCanvas: CropImageToAspectCanvas,
          CropImageToAspect: CropImageToAspect,
          ImagedCanvas: ImagedCanvas,
          ImageTransform: ImageTransform,
          HalfScaleCanvas: HalfScaleCanvas,
          ImageDownScaleAsCanvas: ImageDownScaleAsCanvas,
          ImageDownScale: ImageDownScale,
          URIScaletoURI: URIScaletoURI,
          CropedCanvas: CropedCanvas,
          AsCropedDataURI: AsCropedDataURI
        };
      });
    };
    return gen(angular.module('wlad-image', []));
  });

}).call(this);
