#!/bin/sh

root=~/prod/util.auth
http=node_modules/.bin/http-server

forever start --workingDir ${root} ${http} ./test -p 8014