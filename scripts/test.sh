#! /bin/bash
./node_modules/.bin/brunch watch --server --port 3010 & pid=$!
sleep 6
./node_modules/.bin/mocha-phantomjs --reporter dot http://localhost:3010/test
status=$?
kill $pid
exit $status
