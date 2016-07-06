#!/bin/bash

if [ "$(ls -A .)" ]; then
  echo "Try to fetch update"
  if git checkout $GIT_BRANCH | grep -q 'up-to-date'; then
    echo "Source is up-to-date"
  else
    echo "Update dependencies"
    npm install
    bower install
  fi
else
  echo "Try to clone source"
  chmod 400 ../$GIT_KEY && eval "$(ssh-agent -s)" && ssh-add ../$GIT_KEY && git clone -b $GIT_BRANCH $GIT_REPO .
  echo "Update dependencies"
  npm install
  bower install
fi

sed -i \
    -e "s/^\s*port:.*/port: 80,/" \
    -e "s/^\s*host:.*/host: '0.0.0.0'/" \
    gulpfile.js

sed -i \
    -e "s|^\s*.constant('apiUrl'.*|.constant('serverUrl', '$API_HOST')|" \
    -e "s|^\s*.constant('serverUrl'.*|.constant('serverUrl', '$API_HOST')|" \
    scripts/Constant/Constant.js

gulp sass
gulp
