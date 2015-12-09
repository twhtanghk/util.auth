require 'util.auth'

angular.module 'util.auth.cordova', ['util.auth', 'ngCordova']
	
	.config ($cordovaInAppBrowserProvider) ->
		document.addEventListener 'deviceready', ->
			$cordovaInAppBrowserProvider.setDefaultOptions
				location: 'no'
				clearsessioncache: 'no'
				clearcache: 'no'
				toolbar: 'no'
				
	.config ($provide) ->
		$provide.decorator 'authService', ($rootScope, $delegate, $cordovaInAppBrowser) ->
			document.addEventListener 'deviceready', ->
				isInAppBrowserInstalled = ->
					["cordova-plugin-inappbrowser", "org.apache.cordova.inappbrowser"].some (name) ->
						cordova.require("cordova/plugin_list").metadata.hasOwnProperty name
				
				if isInAppBrowserInstalled()
					$delegate.prompt = (url) ->
						$rootScope.$on '$cordovaInAppBrowser:loadstart', (e, event) ->
							$delegate.check event.url
						$rootScope.$on '$cordovaInAppBrowser:loaderror', (e, event) ->
							$delegate.close()
						$cordovaInAppBrowser.open url, '_blank' 
					
					$delegate.close = ->
						$cordovaInAppBrowser.close()
				
			return $delegate