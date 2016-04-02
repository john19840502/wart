require.config
  appDir: ''
  baseUrl: './app'
  urlArgs: "bust=" + Math.random().toString()
  paths:
    'lib': '../lib'
    'service': 'services'
    'component': 'components'
    'controllers': 'controllers'
    'domReady': '../lib/requirejs-domready/domReady'
    'angular': '../lib/angular/angular'
    'angular-route': '../lib/angular-route/angular-route'
    'angular-resource': '../lib/angular-resource/angular-resource'
    'angular-animate': '../lib/angular-animate/angular-animate'

    'mindspace.utils': '../lib/angular-logX/release/amd/angular-logX.min'
    'lib/jquery': '../lib/jquery/dist/jquery.min'
    'lib/bootstrap': '../lib/bootstrap/dist/js/bootstrap.min'
  bundles:
    'mindspace.utils': [
      'mindspace/logger/ExternalLogger'
      'mindspace/utils/supplant'
      'mindspace/utils/makeTryCatch'
    ]
  shim:
    angular:
      exports: 'angular'
  deps: [
    './bootstrap'
  ]


