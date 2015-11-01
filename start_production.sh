#!/bin/bash
set -e
if [ -z "$PORT" ] && [ -z "$1" ]; then
    echo "Please set the \$PORT environment variable or call the script as ./$0 PORT"
    exit -1
else
    if [ -n "$1" ]; then
        PORT=$1
    fi
fi
export RAILS_ENV=production
bundle
rake db:migrate
rake assets:precompile
bundle exec sidekiq&
rails server -p $PORT
