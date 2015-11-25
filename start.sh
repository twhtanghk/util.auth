#!/bin/sh

root=~/prod/util.auth
cmd=node_modules/.bin/http-server

forever start --workingDir ${root} -a -l util.auth.log -c ${cmd} ./test -p 8014
