var $, URL, _;

$ = require('jquery');

$.deparam = require('jquery-deparam');

_ = require('lodash');

require('sails-auth');

URL = require('url');

angular.module('util.auth', ['ionic', 'http-auth-interceptor']).config(function($provide) {
  return $provide.decorator('authService', function($delegate, $http, $sailsSocket, $rootScope, $ionicModal) {
    var loginConfirmed;
    loginConfirmed = $delegate.loginConfirmed;
    $delegate.loginConfirmed = function(data, configUpdater) {
      if (data != null) {
        $http.defaults.headers.common.Authorization = "Bearer " + data.access_token;
        $sailsSocket.defaults.headers.common.Authorization = "Bearer " + data.access_token;
        return loginConfirmed(null, function(config) {
          config.headers = _.omit(config.headers, 'Authorization');
          return config;
        });
      }
    };
    $delegate.prompt = function(url) {
      var template;
      template = "<ion-modal-view>\n	<ion-content>\n		<iframe src='" + url + "'>\n		</iframe>\n	</ion-content>\n</ion-modal-view>";
      $rootScope.loginModal = $ionicModal.fromTemplate(template);
      return $rootScope.loginModal.show();
    };
    $delegate.close = function() {
      return $rootScope.loginModal.remove();
    };
    $delegate.check = function(url) {
      var data, err, path;
      if (url.match(/error|access_token/)) {
        path = URL.parse(url);
        data = $.deparam(/(?:[#\/]*)(.*)/.exec(path.hash)[1]);
        err = $.deparam(/\?*(.*)/.exec(path.search)[1]);
        if (err.error) {
          $delegate.close();
          return $delegate.loginCancelled(null, err.error);
        } else {
          $delegate.close();
          return $delegate.loginConfirmed(data);
        }
      }
    };
    window.addEventListener('message', function(event) {
      return $delegate.check(event.data);
    });
    $delegate.login = function(opts) {
      var isUnderLogin, url;
      isUnderLogin = false;
      url = function(opts) {
        return opts.authUrl + "?" + ($.param(_.pick(opts, 'client_id', 'scope', 'response_type')));
      };
      $rootScope.$on('event:auth-forbidden', function() {
        if (!isUnderLogin) {
          isUnderLogin = true;
          return $delegate.prompt(url(opts));
        }
      });
      $rootScope.$on('event:auth-loginRequired', function() {
        if (!isUnderLogin) {
          isUnderLogin = true;
          return $delegate.prompt(url(opts));
        }
      });
      $rootScope.$on('event:auth-loginConfirmed', function() {
        return isUnderLogin = false;
      });
      return $rootScope.$on('event:auth-loginCancelled', function() {
        return isUnderLogin = false;
      });
    };
    return $delegate;
  });
});
