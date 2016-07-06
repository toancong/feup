#!/bin/bash

mkdir -p ../node_modules && ln -sf /data/www/node_modules .
mkdir -p ../bower_components && ln -sf /data/www/bower_components .
ln -sf /data/www/bower_components app

bower install
npm install

node -e "require(\"wiredep\")({src:\"app/index.html\"})"
gulp bower
gulp

# development
gulp serve
