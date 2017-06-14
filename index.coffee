$ = require 'jquery'
$.deparam = require 'jquery-deparam'
_ = require 'lodash'
require 'sails-auth'
URL = require 'url'

angular.module 'util.auth', ['ionic', 'http-auth-interceptor']

	.config ($provide) ->
		$provide.decorator 'authService', ($delegate, $http, $sailsSocket, $rootScope, $ionicModal) ->
			loginConfirmed = $delegate.loginConfirmed
			# set authorization header once oauth2 token is available
			$delegate.loginConfirmed = (data, configUpdater) ->
				if data?
					$http.defaults.headers.common.Authorization = "Bearer #{data.access_token}"
					$sailsSocket.defaults.headers.common.Authorization = "Bearer #{data.access_token}"
					loginConfirmed null, (config) ->
						config.headers = _.omit config.headers, 'Authorization'
						return config
				
			# prompt popup dialog for user to login
			$delegate.prompt = (url) ->
				template = """
					<ion-modal-view>
						<ion-content>
							<iframe src='#{url}'>
							</iframe>
						</ion-content>
					</ion-modal-view>
				"""
				$rootScope.loginModal = $ionicModal.fromTemplate template
				$rootScope.loginModal.show() 
			
			# close the popup dialog once token available
			$delegate.close = ->
				$rootScope.loginModal.remove()
				
			# check url to determine if token is available
			$delegate.check = (url) ->
				if url.match(/error|access_token/)
					path = URL.parse url
					data = $.deparam /(?:[#\/]*)(.*)/.exec(path.hash)[1]	# remove leading / or #
					err = $.deparam /\?*(.*)/.exec(path.search)[1]			# remove leading ?
					if err.error
						$delegate.close()
						$delegate.loginCancelled null, err.error
					else
						$delegate.close()
						$delegate.loginConfirmed data
						
			window.addEventListener 'message', (event) ->
				$delegate.check event.data
			
			$delegate.login = (opts) ->
				isUnderLogin = false
			
				url = (opts) ->
					"#{opts.authUrl}?#{$.param(_.pick(opts, 'client_id', 'scope', 'response_type'))}"
			
				$rootScope.$on 'event:auth-forbidden', ->
					if not isUnderLogin
						isUnderLogin = true 
						$delegate.prompt(url(opts))
						
				$rootScope.$on 'event:auth-loginRequired', ->
					if not isUnderLogin
						isUnderLogin = true 
						$delegate.prompt(url(opts))
					
				$rootScope.$on 'event:auth-loginConfirmed', ->
					isUnderLogin = false
					
				$rootScope.$on 'event:auth-loginCancelled', ->
					isUnderLogin = false
				
			return $delegate
