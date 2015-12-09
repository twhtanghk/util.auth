require('util.auth');

angular.module('util.auth.cordova', ['util.auth', 'ngCordova']).config(function($cordovaInAppBrowserProvider) {
  return document.addEventListener('deviceready', function() {
    return $cordovaInAppBrowserProvider.setDefaultOptions({
      location: 'no',
      clearsessioncache: 'no',
      clearcache: 'no',
      toolbar: 'no'
    });
  });
}).config(function($provide) {
  return $provide.decorator('authService', function($rootScope, $delegate, $cordovaInAppBrowser) {
    document.addEventListener('deviceready', function() {
      var isInAppBrowserInstalled;
      isInAppBrowserInstalled = function() {
        return ["cordova-plugin-inappbrowser", "org.apache.cordova.inappbrowser"].some(function(name) {
          return cordova.require("cordova/plugin_list").metadata.hasOwnProperty(name);
        });
      };
      if (isInAppBrowserInstalled()) {
        $delegate.prompt = function(url) {
          $rootScope.$on('$cordovaInAppBrowser:loadstart', function(e, event) {
            return $delegate.check(event.url);
          });
          $rootScope.$on('$cordovaInAppBrowser:loaderror', function(e, event) {
            return $delegate.close();
          });
          return $cordovaInAppBrowser.open(url, '_blank');
        };
        return $delegate.close = function() {
          return $cordovaInAppBrowser.close();
        };
      }
    });
    return $delegate;
  });
});
