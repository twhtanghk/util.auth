env = require './env.coffee'
require '../index.js'
require './model.coffee'
_ = require 'lodash'

angular.module 'app', ['util.auth', 'starter.model']
	.run (authService) ->
		authService.login env.oauth2.opts
		
	.controller 'UsersCtrl', ($scope, resource) ->
		users = new resource.Users()
		users.$fetch()
			.catch alert
		_.extend $scope,
			collection: users
			loadMore: ->
				users.$fetch(params: page: (users.state.skip / users.state.limit + 1))
					.then ->
						$scope.$broadcast('scroll.infiniteScrollComplete')
					.catch alert