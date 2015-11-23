env = require './env.coffee'
require 'PageableAR'
_ = require 'lodash'
		
urlRoot = (model, url, root = env.server.app.urlRoot) ->
	if model.transport() == 'io' then "#{url}" else "#{root}#{url}"
		
resource = ($rootScope, pageableAR, $http) ->
		
	class User extends pageableAR.Model
		$idAttribute:	'username'
		
		$urlRoot: ->
			urlRoot(@, "/api/users")
					
	class Users extends pageableAR.PageableCollection
		$urlRoot: ->
			urlRoot(@, "/api/users/")
		
		model: User
			
	User:			User
	Users:			Users

angular.module('starter.model', ['ionic', 'PageableAR'])
	.factory 'resource', ['$rootScope', 'pageableAR', '$http', resource]