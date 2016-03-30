#! /usr/bin/env bash

set -e

bundle install --local --quiet || bundle install

case $1 in
  "serve")
    bundle exec rake start
  ;;

  "test")
    echo "Starting unit tests"
    bundle exec rake spec
    echo "Starting contract tests"
    RACK_ENV=test bundle exec rake start 1> /dev/null 2>&1 &
    sleep 5
    RACK_ENV=test bundle exec rake validate
    pkill -f "rackup -p 4567" 
  ;;

  "reset")
    bundle exec rake db:reset
  ;;

  *)
    echo "Invalid Command"
  ;;
esac
