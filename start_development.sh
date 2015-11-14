#!/bin/bash
set -e
if [ -z "$PORT" ]; then
    PORT=3000
fi
if [ -n "$1" ]; then
    PORT=$1
fi
bundle
bundle exec rake db:migrate
bundle exec sidekiq&
bundle exec rails server -p $PORT $ARGS
