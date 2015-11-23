# util.auth
util.auth is an angular module for application to verify user login via pre-defined oauth2 server on pop-up iframe. 

## Usage
Install the package
```
npm install util.auth
```

Define oauth2 server settings 
```
	oauth2:
		opts:
			authUrl: "https://mob.myvnc.com/org/oauth2/authorize/"
			response_type:	"token"
			scope:			"https://mob.myvnc.com/org/users"
			client_id:		'util.auth'
```

Include other required packages
```
	require 'util.auth'
	_ = require 'lodash'
```

Include sails.io.js and disable it if only rest request is required and web socket connection is not necessary
```
	<script type="text/javascript" src="lib/sails.io.js/dist/sails.io.js"></script>
	<script type="text/javascript">
		io.sails.autoConnect = false;
	</script>
```

Run login via the pre-defined oauth2 server settings once 401 Unauthorized Access is received 
```
angular.module 'app', ['util.auth', ...]
	.run (authService) ->
		authService.login env.oauth2.opts
```

## Demo
Open browser to visit https://mob.myvnc.com/util.auth.

Deploy to local testing server
```
  npm install && bower install
  node_modules/.bin/gulp
  node_modules/.bin/http-server
```
open browser to visit http://localhost:8080/test/ or https://mob.myvnc.com/util.auth