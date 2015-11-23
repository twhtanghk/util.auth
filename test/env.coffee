module.exports =
	server:
		app:
			urlRoot:	'https://mob.myvnc.com/org'
	oauth2:
		opts:
			authUrl: "https://mob.myvnc.com/org/oauth2/authorize/"
			response_type:	"token"
			scope:			"https://mob.myvnc.com/org/users"
			client_id:		'util.auth'