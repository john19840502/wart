define [], ()->
  gen= (module)->
    'use strict'
    module.factory 'WladImage', ()->
      ReadFileURI = (file, func)->
        reader = new FileReader()
        reader.onload = ()->
          func reader.result
        reader.readAsDataURL file
        reader

      URIImageLoad = (uri, func)->
        tempImg = new Image()
        tempImg.onload = ()->
          func @
        tempImg.src = uri
        tempImg

      fileToImage = (file, func)->
        ReadFileURI file, (uri)->
          URIImageLoad uri, func

      CropImageCanvas = (img, x, y, w, h, onready)->
        canvas = document.createElement 'canvas'
        canvas.width = w
        canvas.height = h
        ctx = canvas.getContext "2d"
        ctx.drawImage img, x, y, w, h, 0, 0, w, h
        onready canvas

      CropImage = (img, x, y, w, h, onready)->
        CropImageCanvas img, x, y, w, h, (cc)->
          URIImageLoad cc.toDataURL('image/png'), onready

      getCropAspectParams = (img, a)->  # a=x/y
        #  var x, y, w, h;
        ia = img.width / img.height
        if ia > a                      #// shire
          w = Math.round img.height * a
          x = Math.round (img.width - w) / 2.0
          y = 0
          h = img.height
        else                            #  //vishe
          h = Math.round img.width * a
          y = Math.round (img.height - h) / 2.0
          x = 0;
          w = img.width
        {x, y, w, h}

      CropImageToAspectCanvas = (img, a, onready)->#  // a=x/y
        p = getCropAspectParams img, a
        CropImageCanvas img, p.x, p.y, p.w, p.h, onready

      CropImageToAspect = (img, a, onready) -> # // a=x/y
        p = getCropAspectParams img, a
        CropImage img, p.x, p.y, p.w, p.h, onready

      ImagedCanvas = (canvas, img, w, h, func)->
        if !canvas?
          canvas = document.createElement 'canvas'
        canvas.width = w
        canvas.height = h
        ctx = canvas.getContext "2d"
        ctx.drawImage img, 0, 0, img.width, img.height, 0, 0, w, h
        func canvas

      ImageTransform = (img, w, h, func)->
        ImagedCanvas null, img, w, h, (c)->
          URIImageLoad c.toDataURL('image/png'), func

      HalfScaleCanvas = (c)->
        hc = document.createElement 'canvas'
        hc.width = c.width / 2
        hc.height = c.height / 2
        hc.getContext('2d').drawImage c, 0, 0, hc.width, hc.height
        hc

      ImageDownScaleAsCanvas = (tx, img, func)->
        while img.width > tx * 2
          img = HalfScaleCanvas img
        a = img.height / img.width
        ImagedCanvas null, img, tx, Math.round(tx * a), func

      ImageDownScale = (tx, img, func)->
        ImageDownScaleAsCanvas tx, img, (c)->
          URIImageLoad c.toDataURL('image/png'), func

      URIScaletoURI = (uri, sx, func) ->
        URIImageLoad uri, (img)->
          ImageDownScaleAsCanvas sx, img, (c)->
            func c.toDataURL('image/png')

      CropedCanvas = (file, sx, sy, onready)->
        fileToImage file, (img)->
          CropImageToAspect img, sx / sy, (_img)->
            ImageDownScaleAsCanvas sx, _img, onready

      AsCropedDataURI = (file, sx, sy, onready)->
        CropedCanvas file, sx, sy, (c) ->
          onready c.toDataURL('image/png')

      { ReadFileURI, URIImageLoad, fileToImage, CropImageCanvas, CropImage,
      getCropAspectParams, CropImageToAspectCanvas,
      CropImageToAspect, ImagedCanvas, ImageTransform, HalfScaleCanvas,
      ImageDownScaleAsCanvas, ImageDownScale, URIScaletoURI,
      CropedCanvas, AsCropedDataURI
      }
  gen angular.module 'wlad-image', []
